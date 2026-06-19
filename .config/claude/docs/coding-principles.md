# Coding Principles

すべてのコーディングタスクで遵守する言語非依存の一般原則。

- コード中のコメントやメッセージは英語で記述してください。
- ユーザーからの指示や仕様に疑問などがあれば作業を中断し、質問すること。
- 一般的なコーディング規約を遵守すること。（Python プロジェクトであれば PEP8）
- レポジトリ直下に `.pre-commit-config.yaml` がある場合は、編集後のコードが pre-commit をパスすることを確認すること。
- 特に指定されない限り**後方互換性は無視**し、できる限りシンプルなコードを書くこと。
- 保守性を重視し、冗長なコードや複雑なコードは避けること。

## Avoid over-engineering

Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused:

- **Scope:** Don't add features, refactor code, or make "improvements" beyond what was asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need extra configurability.
- **Documentation:** Don't add docstrings, comments, or type annotations to code you didn't change. Only add comments where the logic isn't self-evident.
- **Defensive coding:** Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs).
- **Abstractions:** Don't create helpers, utilities, or abstractions for one-time operations. Don't design for hypothetical future requirements. The right amount of complexity is the minimum needed for the current task.
