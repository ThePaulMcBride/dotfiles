---
name: tdd
description: Test-driven development workflow for implementing changes safely and incrementally. Use when adding features, fixing bugs, or refactoring code with test coverage.
---

# Test-Driven Development

Prefer a red/green/refactor workflow when practical.

## Process

1. **Red**: write or identify a failing test that captures the desired behavior.
2. **Green**: make the smallest implementation change needed to pass the test.
3. **Refactor**: improve the code while keeping tests green.

## Guidelines

- Write tests that verify behavior, not implementation details.
- Keep tests focused; each test should fail for a clear reason.
- Avoid redundant coverage.
- If a bug report is vague, first create a minimal reproduction.
- If changing existing behavior intentionally, update or replace tests to reflect the new contract.

## When not to force TDD

If the codebase has no meaningful test harness, or the change is purely config/docs, adapt the workflow rather than inventing brittle tests.
