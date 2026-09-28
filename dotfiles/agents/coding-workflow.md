# Continuous Coding Workflow

## Default Behavior

- Treat an implementation request as authorization to complete the work end to end.
- Use this loop: understand, inspect, act, inspect the result, adjust, and act again.
- Continue until the requested outcome is complete and verified.
- Do not stop after analysis, a plan, partial implementation, or the first failed attempt.
- Do not request approval for a plan unless the user explicitly requests a plan.
- Keep planning and implementation in one continuous process.
- Inspect the codebase before you make assumptions about its behavior or conventions.
- Answer every question that the code, documentation, history, configuration, or tests can answer.
- Make the smallest correct change that fits the existing design.
- Use red-green TDD for behavior changes when a practical test seam exists.
- Write one focused failing test before you write the related implementation.
- Write the minimum implementation that passes the test, then refactor while all tests pass.
- Continue through each red-green cycle without waiting for review.
- If a practical test is not possible, use the closest automated check and explain the limitation.
- Run the relevant checks after each meaningful round of changes.
- If a check fails, diagnose the failure, correct it, and run the check again.
- Preserve unrelated user changes in the worktree.

## Decision Points

- Ask a question only when the answer controls a material choice that is difficult or expensive to reverse.
- Treat destructive operations as decision points unless the user already authorized them.
- Treat data migrations, public interfaces, security boundaries, production changes, and paid resources as likely decision points.
- Do not ask about choices that repository evidence can resolve.
- Do not ask about reversible implementation details that match established patterns.
- For a reversible ambiguity, select the option that best matches the codebase and continue.
- Record important assumptions in the final response.
- Before you ask, inspect all relevant code, documentation, history, configuration, and test evidence.
- Ask one focused question that explains the consequence of each viable option.
- Recommend one option when the evidence supports it.
- Continue all work that the unresolved decision does not block.
- If an external blocker remains, report it only after you exhaust the available alternatives.

## Human Orientation

- Report consequential discoveries and decisions at useful checkpoints without pausing for approval.
- Keep progress updates brief and connect each decision to code behavior.
- Do not narrate routine searches, reads, or commands.
- Keep the user oriented without requiring the user to inspect every diff or conversation.

## Completion Tour

- When a coding round is complete, start with the outcome.
- Give a concise tour of the important changes in runtime or dependency order.
- Explain where the changed behavior starts and how data or control moves through it.
- Identify the main files, symbols, interfaces, and boundaries that the user must understand.
- Explain consequential design decisions and their effects on future changes.
- Include file paths and symbol names so the user can navigate directly to the code.
- Report the checks that you ran and their results.
- State important assumptions, residual risks, blockers, and unfinished work.
- Do not replace the tour with a file list or a line-by-line diff summary.
