---
name: code-review
description: Structured code review guidance focused on correctness, maintainability, risk, and missing tests. Use when reviewing a diff, proposed implementation, or refactor.
---

# Code Review

Review code with emphasis on user impact and maintainability.

## Priorities

1. Correctness and regressions
2. Security and data safety
3. Missing tests or weak validation
4. API and behavior changes
5. Readability and maintainability
6. Performance issues that matter in practice

## Review style

- Lead with the highest-signal issues.
- Be specific about why something is risky.
- Prefer actionable suggestions over vague criticism.
- If something looks fine, say that briefly rather than inventing issues.
- Distinguish must-fix issues from nice-to-have improvements.
