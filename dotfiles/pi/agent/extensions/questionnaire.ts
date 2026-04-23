/**
 * Questionnaire Tool - Unified tool for asking single or multiple questions
 *
 * Single question: simple options list
 * Multiple questions: tab bar navigation between questions
 */

import { BorderedLoader } from "@mariozechner/pi-coding-agent";
import type { ExtensionAPI, ExtensionContext, ExtensionCommandContext } from "@mariozechner/pi-coding-agent";
import { complete, type UserMessage } from "@mariozechner/pi-ai";
import { Editor, type EditorTheme, Key, matchesKey, Text, truncateToWidth } from "@mariozechner/pi-tui";
import { Type } from "@sinclair/typebox";

interface QuestionOption {
	value: string;
	label: string;
	description?: string;
}

type RenderOption = QuestionOption & { isOther?: boolean };

interface Question {
	id: string;
	label: string;
	prompt: string;
	options: QuestionOption[];
	allowOther: boolean;
}

interface Answer {
	id: string;
	value: string;
	label: string;
	wasCustom: boolean;
	index?: number;
}

interface QuestionnaireResult {
	questions: Question[];
	answers: Answer[];
	cancelled: boolean;
}

interface ExtractedQuestion {
	question: string;
	label?: string;
	options?: QuestionOption[];
	allowOther?: boolean;
}

const QuestionOptionSchema = Type.Object({
	value: Type.String({ description: "The value returned when selected" }),
	label: Type.String({ description: "Display label for the option" }),
	description: Type.Optional(Type.String({ description: "Optional description shown below label" })),
});

const QuestionSchema = Type.Object({
	id: Type.String({ description: "Unique identifier for this question" }),
	label: Type.Optional(
		Type.String({
			description: "Short contextual label for tab bar, e.g. 'Scope', 'Priority' (defaults to Q1, Q2)",
		}),
	),
	prompt: Type.String({ description: "The full question text to display" }),
	options: Type.Array(QuestionOptionSchema, { description: "Available options to choose from" }),
	allowOther: Type.Optional(Type.Boolean({ description: "Allow 'Type something' option (default: true)" })),
});

const QuestionnaireParams = Type.Object({
	questions: Type.Array(QuestionSchema, { description: "Questions to ask the user" }),
});

const ASK_EXTRACT_SYSTEM_PROMPT = `You extract clarification questions from assistant messages.

Return strict JSON only. No markdown, no prose, no code fences.

Schema:
{
  "questions": [
    {
      "question": "string",
      "label": "optional short label",
      "options": [
        { "value": "string", "label": "string", "description": "optional string" }
      ],
      "allowOther": true
    }
  ]
}

Rules:
- Extract only questions the user still needs to answer.
- Use the order they appeared in.
- If the assistant offered explicit choices, convert them into options.
- If choices are unclear or absent, use an empty options array and allowOther=true.
- Keep question text concise but faithful.
- If there are no unanswered questions, return {"questions":[]}.
`;

function errorResult(
	message: string,
	questions: Question[] = [],
): { content: { type: "text"; text: string }[]; details: QuestionnaireResult } {
	return {
		content: [{ type: "text", text: message }],
		details: { questions, answers: [], cancelled: true },
	};
}

function normalizeQuestions(inputQuestions: Question[]): Question[] {
	return inputQuestions.map((q, i) => ({
		...q,
		label: q.label || `Q${i + 1}`,
		allowOther: q.allowOther !== false,
	}));
}

async function runQuestionnaire(ctx: ExtensionContext, inputQuestions: Question[]): Promise<QuestionnaireResult> {
	const questions = normalizeQuestions(inputQuestions);
	const isMulti = questions.length > 1;
	const totalTabs = questions.length + 1;

	return ctx.ui.custom<QuestionnaireResult>((tui, theme, _kb, done) => {
		let currentTab = 0;
		let optionIndex = 0;
		let inputMode = false;
		let inputQuestionId: string | null = null;
		let cachedLines: string[] | undefined;
		const answers = new Map<string, Answer>();

		const editorTheme: EditorTheme = {
			borderColor: (s) => theme.fg("accent", s),
			selectList: {
				selectedPrefix: (t) => theme.fg("accent", t),
				selectedText: (t) => theme.fg("accent", t),
				description: (t) => theme.fg("muted", t),
				scrollInfo: (t) => theme.fg("dim", t),
				noMatch: (t) => theme.fg("warning", t),
			},
		};
		const editor = new Editor(tui, editorTheme);

		function refresh() {
			cachedLines = undefined;
			tui.requestRender();
		}

		function submit(cancelled: boolean) {
			done({ questions, answers: Array.from(answers.values()), cancelled });
		}

		function currentQuestion(): Question | undefined {
			return questions[currentTab];
		}

		function currentOptions(): RenderOption[] {
			const q = currentQuestion();
			if (!q) return [];
			const opts: RenderOption[] = [...q.options];
			if (q.allowOther) {
				opts.push({ value: "__other__", label: "Type something.", isOther: true });
			}
			return opts;
		}

		function allAnswered(): boolean {
			return questions.every((q) => answers.has(q.id));
		}

		function advanceAfterAnswer() {
			if (!isMulti) {
				submit(false);
				return;
			}
			if (currentTab < questions.length - 1) {
				currentTab++;
			} else {
				currentTab = questions.length;
			}
			optionIndex = 0;
			refresh();
		}

		function saveAnswer(questionId: string, value: string, label: string, wasCustom: boolean, index?: number) {
			answers.set(questionId, { id: questionId, value, label, wasCustom, index });
		}

		editor.onSubmit = (value) => {
			if (!inputQuestionId) return;
			const trimmed = value.trim() || "(no response)";
			saveAnswer(inputQuestionId, trimmed, trimmed, true);
			inputMode = false;
			inputQuestionId = null;
			editor.setText("");
			advanceAfterAnswer();
		};

		function handleInput(data: string) {
			if (inputMode) {
				if (matchesKey(data, Key.escape)) {
					inputMode = false;
					inputQuestionId = null;
					editor.setText("");
					refresh();
					return;
				}
				editor.handleInput(data);
				refresh();
				return;
			}

			const q = currentQuestion();
			const opts = currentOptions();

			if (isMulti) {
				if (matchesKey(data, Key.tab) || matchesKey(data, Key.right)) {
					currentTab = (currentTab + 1) % totalTabs;
					optionIndex = 0;
					refresh();
					return;
				}
				if (matchesKey(data, Key.shift("tab")) || matchesKey(data, Key.left)) {
					currentTab = (currentTab - 1 + totalTabs) % totalTabs;
					optionIndex = 0;
					refresh();
					return;
				}
			}

			if (currentTab === questions.length) {
				if (matchesKey(data, Key.enter) && allAnswered()) {
					submit(false);
				} else if (matchesKey(data, Key.escape)) {
					submit(true);
				}
				return;
			}

			if (matchesKey(data, Key.up)) {
				optionIndex = Math.max(0, optionIndex - 1);
				refresh();
				return;
			}
			if (matchesKey(data, Key.down)) {
				optionIndex = Math.min(opts.length - 1, optionIndex + 1);
				refresh();
				return;
			}

			if (matchesKey(data, Key.enter) && q) {
				const opt = opts[optionIndex];
				if (opt.isOther) {
					inputMode = true;
					inputQuestionId = q.id;
					editor.setText("");
					refresh();
					return;
				}
				saveAnswer(q.id, opt.value, opt.label, false, optionIndex + 1);
				advanceAfterAnswer();
				return;
			}

			if (matchesKey(data, Key.escape)) {
				submit(true);
			}
		}

		function render(width: number): string[] {
			if (cachedLines) return cachedLines;

			const lines: string[] = [];
			const q = currentQuestion();
			const opts = currentOptions();
			const add = (s: string) => lines.push(truncateToWidth(s, width));

			add(theme.fg("accent", "─".repeat(width)));

			if (isMulti) {
				const tabs: string[] = ["← "];
				for (let i = 0; i < questions.length; i++) {
					const isActive = i === currentTab;
					const isAnswered = answers.has(questions[i].id);
					const lbl = questions[i].label;
					const box = isAnswered ? "■" : "□";
					const color = isAnswered ? "success" : "muted";
					const text = ` ${box} ${lbl} `;
					const styled = isActive ? theme.bg("selectedBg", theme.fg("text", text)) : theme.fg(color, text);
					tabs.push(`${styled} `);
				}
				const canSubmit = allAnswered();
				const isSubmitTab = currentTab === questions.length;
				const submitText = " ✓ Submit ";
				const submitStyled = isSubmitTab
					? theme.bg("selectedBg", theme.fg("text", submitText))
					: theme.fg(canSubmit ? "success" : "dim", submitText);
				tabs.push(`${submitStyled} →`);
				add(` ${tabs.join("")}`);
				lines.push("");
			}

			function renderOptions() {
				for (let i = 0; i < opts.length; i++) {
					const opt = opts[i];
					const selected = i === optionIndex;
					const isOther = opt.isOther === true;
					const prefix = selected ? theme.fg("accent", "> ") : "  ";
					const color = selected ? "accent" : "text";
					if (isOther && inputMode) {
						add(prefix + theme.fg("accent", `${i + 1}. ${opt.label} ✎`));
					} else {
						add(prefix + theme.fg(color, `${i + 1}. ${opt.label}`));
					}
					if (opt.description) {
						add(`     ${theme.fg("muted", opt.description)}`);
					}
				}
			}

			if (inputMode && q) {
				add(theme.fg("text", ` ${q.prompt}`));
				lines.push("");
				renderOptions();
				lines.push("");
				add(theme.fg("muted", " Your answer:"));
				for (const line of editor.render(width - 2)) {
					add(` ${line}`);
				}
				lines.push("");
				add(theme.fg("dim", " Enter to submit • Esc to cancel"));
			} else if (currentTab === questions.length) {
				add(theme.fg("accent", theme.bold(" Ready to submit")));
				lines.push("");
				for (const question of questions) {
					const answer = answers.get(question.id);
					if (answer) {
						const prefix = answer.wasCustom ? "(wrote) " : "";
						add(`${theme.fg("muted", ` ${question.label}: `)}${theme.fg("text", prefix + answer.label)}`);
					}
				}
				lines.push("");
				if (allAnswered()) {
					add(theme.fg("success", " Press Enter to submit"));
				} else {
					const missing = questions
						.filter((question) => !answers.has(question.id))
						.map((question) => question.label)
						.join(", ");
					add(theme.fg("warning", ` Unanswered: ${missing}`));
				}
			} else if (q) {
				add(theme.fg("text", ` ${q.prompt}`));
				lines.push("");
				renderOptions();
			}

			lines.push("");
			if (!inputMode) {
				const help = isMulti
					? " Tab/←→ navigate • ↑↓ select • Enter confirm • Esc cancel"
					: " ↑↓ navigate • Enter select • Esc cancel";
				add(theme.fg("dim", help));
			}
			add(theme.fg("accent", "─".repeat(width)));

			cachedLines = lines;
			return lines;
		}

		return {
			render,
			invalidate: () => {
				cachedLines = undefined;
			},
			handleInput,
		};
	});
}

function getRecentAssistantText(ctx: ExtensionCommandContext, count = 3): string | undefined {
	const branch = ctx.sessionManager.getBranch();
	const chunks: string[] = [];

	for (let i = branch.length - 1; i >= 0 && chunks.length < count; i--) {
		const entry = branch[i];
		if (entry.type !== "message") continue;
		const msg = entry.message;
		if (!("role" in msg) || msg.role !== "assistant") continue;
		if (msg.stopReason !== "stop") continue;

		const text = msg.content
			.filter((c): c is { type: "text"; text: string } => c.type === "text")
			.map((c) => c.text)
			.join("\n")
			.trim();

		if (text) chunks.unshift(text);
	}

	if (chunks.length === 0) return undefined;
	return chunks.join("\n\n---\n\n");
}

function parseExtractedQuestions(raw: string): ExtractedQuestion[] {
	try {
		const parsed = JSON.parse(raw) as { questions?: ExtractedQuestion[] };
		if (!Array.isArray(parsed.questions)) return [];
		return parsed.questions.filter((q) => typeof q?.question === "string" && q.question.trim().length > 0);
	} catch {
		return [];
	}
}

function extractedToQuestionnaireQuestions(extracted: ExtractedQuestion[]): Question[] {
	return extracted.map((q, index) => ({
		id: `q${index + 1}`,
		label: q.label || `Q${index + 1}`,
		prompt: q.question.trim(),
		options: Array.isArray(q.options) ? q.options : [],
		allowOther: q.allowOther !== false,
	}));
}

function answersToDraft(result: QuestionnaireResult): string {
	return result.answers
		.map((answer) => {
			const question = result.questions.find((q) => q.id === answer.id);
			const prompt = question?.prompt || answer.id;
			return `Q: ${prompt}\nA: ${answer.label}`;
		})
		.join("\n\n");
}

export default function questionnaire(pi: ExtensionAPI) {
	pi.registerTool({
		name: "questionnaire",
		label: "Questionnaire",
		description:
			"Ask the user one or more questions. Use for clarifying requirements, getting preferences, or confirming decisions. For single questions, shows a simple option list. For multiple questions, shows a tab-based interface.",
		parameters: QuestionnaireParams,

		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			if (!ctx.hasUI) {
				return errorResult("Error: UI not available (running in non-interactive mode)");
			}
			if (params.questions.length === 0) {
				return errorResult("Error: No questions provided");
			}

			const result = await runQuestionnaire(ctx, params.questions);
			if (result.cancelled) {
				return {
					content: [{ type: "text", text: "User cancelled the questionnaire" }],
					details: result,
				};
			}

			const answerLines = result.answers.map((answer) => {
				const qLabel = result.questions.find((q) => q.id === answer.id)?.label || answer.id;
				if (answer.wasCustom) return `${qLabel}: user wrote: ${answer.label}`;
				return `${qLabel}: user selected: ${answer.index}. ${answer.label}`;
			});

			return {
				content: [{ type: "text", text: answerLines.join("\n") }],
				details: result,
			};
		},

		renderCall(args, theme, _context) {
			const qs = (args.questions as Question[]) || [];
			const count = qs.length;
			const labels = qs.map((q) => q.label || q.id).join(", ");
			let text = theme.fg("toolTitle", theme.bold("questionnaire "));
			text += theme.fg("muted", `${count} question${count !== 1 ? "s" : ""}`);
			if (labels) text += theme.fg("dim", ` (${truncateToWidth(labels, 40)})`);
			return new Text(text, 0, 0);
		},

		renderResult(result, _options, theme, _context) {
			const details = result.details as QuestionnaireResult | undefined;
			if (!details) {
				const text = result.content[0];
				return new Text(text?.type === "text" ? text.text : "", 0, 0);
			}
			if (details.cancelled) return new Text(theme.fg("warning", "Cancelled"), 0, 0);
			const lines = details.answers.map((answer) => {
				if (answer.wasCustom) {
					return `${theme.fg("success", "✓ ")}${theme.fg("accent", answer.id)}: ${theme.fg("muted", "(wrote) ")}${answer.label}`;
				}
				const display = answer.index ? `${answer.index}. ${answer.label}` : answer.label;
				return `${theme.fg("success", "✓ ")}${theme.fg("accent", answer.id)}: ${display}`;
			});
			return new Text(lines.join("\n"), 0, 0);
		},
	});

	pi.registerCommand("ask", {
		description: "Extract recent assistant questions and present them as a questionnaire",
		handler: async (_args, ctx) => {
			if (!ctx.hasUI) {
				ctx.ui.notify("ask requires interactive mode", "error");
				return;
			}
			if (!ctx.model) {
				ctx.ui.notify("No model selected", "error");
				return;
			}

			const recentAssistantText = getRecentAssistantText(ctx, 3);
			if (!recentAssistantText) {
				ctx.ui.notify("No recent assistant messages found", "error");
				return;
			}

			const extractedRaw = await ctx.ui.custom<string | null>((tui, theme, _kb, done) => {
				const loader = new BorderedLoader(tui, theme, `Extracting questions using ${ctx.model!.id}...`);
				loader.onAbort = () => done(null);

				const doExtract = async () => {
					const auth = await ctx.modelRegistry.getApiKeyAndHeaders(ctx.model!);
					if (!auth.ok || !auth.apiKey) {
						throw new Error(auth.ok ? `No API key for ${ctx.model!.provider}` : auth.error);
					}

					const userMessage: UserMessage = {
						role: "user",
						content: [{ type: "text", text: recentAssistantText }],
						timestamp: Date.now(),
					};

					const response = await complete(
						ctx.model!,
						{ systemPrompt: ASK_EXTRACT_SYSTEM_PROMPT, messages: [userMessage] },
						{ apiKey: auth.apiKey, headers: auth.headers, signal: loader.signal },
					);

					if (response.stopReason === "aborted") return null;
					return response.content
						.filter((c): c is { type: "text"; text: string } => c.type === "text")
						.map((c) => c.text)
						.join("\n");
				};

				doExtract().then(done).catch(() => done(null));
				return loader;
			});

			if (extractedRaw === null) {
				ctx.ui.notify("Cancelled", "info");
				return;
			}

			const extracted = parseExtractedQuestions(extractedRaw);
			if (extracted.length === 0) {
				ctx.ui.notify("No unanswered questions found in recent assistant messages", "info");
				return;
			}

			const questions = extractedToQuestionnaireQuestions(extracted);
			const result = await runQuestionnaire(ctx, questions);
			if (result.cancelled) {
				ctx.ui.notify("Questionnaire cancelled", "info");
				return;
			}

			ctx.ui.setEditorText(answersToDraft(result));
			ctx.ui.notify("Answers loaded into editor. Review and submit when ready.", "success");
		},
	});
}
