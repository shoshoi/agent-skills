> 🇬🇧 English (canonical): [cursor-setup.md](cursor-setup.md)

# Cursor で agent-skills を使う

## セットアップ

### 方法 1: ルールディレクトリ（推奨）

Cursor はプロジェクト固有のルールを格納する `.cursor/rules/` ディレクトリをサポートしています。

```bash
# Create the rules directory
mkdir -p .cursor/rules

# Copy skills you want as rules
cp /path/to/agent-skills/skills/test-driven-development/SKILL.md .cursor/rules/test-driven-development.md
cp /path/to/agent-skills/skills/code-review-and-quality/SKILL.md .cursor/rules/code-review-and-quality.md
cp /path/to/agent-skills/skills/incremental-implementation/SKILL.md .cursor/rules/incremental-implementation.md
```

このディレクトリ内のルールは、自動的に Cursor のコンテキストに読み込まれます。

### 方法 2: .cursorrules ファイル

プロジェクトのルートに `.cursorrules` ファイルを作成し、必須のスキルをインライン展開します。

```bash
# Generate a combined rules file
cat /path/to/agent-skills/skills/test-driven-development/SKILL.md > .cursorrules
echo "\n---\n" >> .cursorrules
cat /path/to/agent-skills/skills/code-review-and-quality/SKILL.md >> .cursorrules
```

## 推奨設定

### 必須スキル（常に読み込む）

以下を `.cursor/rules/` に追加します。

1. `test-driven-development.md` — TDD ワークフローと Prove-It パターン
2. `code-review-and-quality.md` — 5観点レビュー
3. `incremental-implementation.md` — 小さく検証可能なスライスでビルドする

### フェーズ別スキル（必要に応じて読み込む）

フェーズ固有の作業については、必要に応じて追加のルールファイルを作成します。

- `spec-development.md` -> `spec-driven-development/SKILL.md`
- `frontend-ui.md` -> `frontend-ui-engineering/SKILL.md`
- `security.md` -> `security-and-hardening/SKILL.md`
- `performance.md` -> `performance-optimization/SKILL.md`

関連するタスクに取り組むときにこれらを `.cursor/rules/` に追加し、完了したらコンテキスト制限を管理するために削除します。

## 使い方のヒント

1. **すべてのスキルを一度に読み込まない** - Cursor にはコンテキスト制限があります。必須スキルを2〜3個ルールとして読み込み、フェーズ固有のスキルは必要に応じて追加します。
2. **スキルを明示的に参照する** - Cursor に「この変更には test-driven-development のルールに従ってください」と伝え、読み込まれたルールを確実に参照させます。
3. **レビューにはエージェントを使う** - `agents/code-reviewer.md` の内容をコピーし、Cursor に「このコードレビューフレームワークを使ってこの差分をレビューしてください」と伝えます。
4. **参考資料は必要に応じて読み込む** - パフォーマンスの作業をするときは、`performance.md` を `.cursor/rules/` に追加するか、チェックリストの内容を直接貼り付けます。
