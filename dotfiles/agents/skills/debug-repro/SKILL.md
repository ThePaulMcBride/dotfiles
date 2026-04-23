---
name: debug-repro
description: Workflow for debugging by building a clear reproduction, narrowing scope, and validating a fix. Use when investigating bugs, flaky behavior, or unclear failures.
---

# Debug Reproduction

Use a reproduction-first workflow.

## Process

1. Restate the observed problem clearly.
2. Identify the smallest reproducible case.
3. Capture inputs, environment, and exact failure symptoms.
4. Narrow the problem space before changing code broadly.
5. Validate the fix against the reproduction.

## Guidelines

- Prefer concrete failing commands, tests, or steps over vague descriptions.
- If the bug is intermittent, note what is known and unknown.
- Separate symptom, cause, and fix in your reasoning.
- If you cannot reproduce it, say so explicitly and explain the next-best diagnostic step.
