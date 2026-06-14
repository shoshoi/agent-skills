> 🇬🇧 English (canonical): [copilot-setup.md](copilot-setup.md)

# GitHub Copilot で agent-skills を使う

## セットアップ

### Copilot Instructions

Copilot は、リポジトリ内の `.github/skills`、`.claude/skills`、または `.agents/skills` ディレクトリを使ったエージェントスキルの作成に対応しています。

```bash
mkdir -p .github

# Create files for essential skills
cat /path/to/agent-skills/skills/test-driven-development/SKILL.md > .github/skills/test-driven-development/SKILL.md
cat /path/to/agent-skills/skills/code-review-and-quality/SKILL.md > .github/skills/code-review-and-quality/SKILL.md
```

詳細については、[GitHub Copilot 向けのエージェントスキルの作成](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-skills) を参照してください。

### エージェントペルソナ (*.agent.md)

Copilot は専門化されたエージェントペルソナに対応しています。agent-skills のエージェントを使いましょう。

> **重要:** GitHub Copilot では、カスタムエージェントファイルを `*.agent.md` という名前にする必要があります。
> `*.md` という名前のファイルは Copilot によって黙って無視されます。
> 詳細は [VS Code のカスタムエージェントドキュメント](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_custom-agent-file-structure) を参照してください。

```bash
# Create the agents directory and copy agent definitions
mkdir -p .github/agents
cp /path/to/agent-skills/agents/code-reviewer.md .github/agents/code-reviewer.agent.md
cp /path/to/agent-skills/agents/test-engineer.md .github/agents/test-engineer.agent.md
cp /path/to/agent-skills/agents/security-auditor.md .github/agents/security-auditor.agent.md
```

Copilot Chat でエージェントを呼び出します。
- `@code-reviewer Review this PR`
- `@test-engineer Analyze test coverage for this module`
- `@security-auditor Check this endpoint for vulnerabilities`

### カスタム命令（ユーザーレベル）

すべてのリポジトリで使いたいスキルがある場合は、次の手順を行います。

1. VS Code を開き、設定 → GitHub Copilot → Custom Instructions を開きます
2. 最もよく使うスキルの要約を追加します

## 推奨構成

### .github/copilot-instructions.md

GitHub Copilot は `.github/copilot-instructions.md` によるプロジェクトレベルの命令に対応しています。

```markdown
# Project Coding Standards

## Testing
- Write tests before code (TDD)
- For bugs: write a failing test first, then fix (Prove-It pattern)
- Test hierarchy: unit > integration > e2e (use the lowest level that captures the behavior)
- Run `npm test` after every change

## Code Quality
- Review across five axes: correctness, readability, architecture, security, performance
- Every PR must pass: lint, type check, tests, build
- No secrets in code or version control

## Implementation
- Build in small, verifiable increments
- Each increment: implement → test → verify → commit
- Never mix formatting changes with behavior changes

## Boundaries
- Always: Run tests before commits, validate user input
- Ask first: Database schema changes, new dependencies
- Never: Commit secrets, remove failing tests, skip verification
```

### 専門化されたエージェント

Copilot Chat で対象を絞ったレビューワークフローを行う際に、これらのエージェントを使いましょう。

## 利用のヒント

1. **命令は簡潔に保つ** — Copilot の命令は焦点を絞ったときに最もうまく機能します。スキルファイル全体を含めるのではなく、重要なルールを要約しましょう。
2. **レビューにエージェントを使う** — code-reviewer、test-engineer、security-auditor のエージェントは、Copilot のエージェントモデル向けに設計されています。
3. **チャットで参照する** — 特定のフェーズに取り組む際は、該当するスキルの内容を Copilot Chat に貼り付けてコンテキストとして与えましょう。
4. **PR レビューと組み合わせる** — code-reviewer エージェントペルソナを使って PR をレビューするように Copilot を設定しましょう。
