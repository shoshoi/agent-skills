> 🇬🇧 English (canonical): [gemini-cli-setup.md](gemini-cli-setup.md)

# Gemini CLI で agent-skills を使う

## セットアップ

### 方法 1: スキルとしてインストールする（推奨）

Gemini CLI にはネイティブのスキルシステムがあり、`.gemini/skills/` または `.agents/skills/` ディレクトリ内の `SKILL.md` ファイルを自動的に検出します。各スキルは、タスクに一致したときに必要に応じて有効化されます。

**リポジトリからインストールする:**

```bash
gemini skills install https://github.com/addyosmani/agent-skills.git --path skills
```

**またはローカルのクローンからインストールする:**

```bash
git clone https://github.com/addyosmani/agent-skills.git
gemini skills install /path/to/agent-skills/skills/
```

**特定のワークスペースだけにインストールする:**

```bash
gemini skills install /path/to/agent-skills/skills/ --scope workspace
```

ワークスペーススコープでインストールしたスキルは `.gemini/skills/`（または `.agents/skills/`）に入ります。ユーザーレベルのスキルは `~/.gemini/skills/` に入ります。

インストールが完了したら、次のコマンドで確認します:

```
/skills list
```

Gemini CLI はスキル名と説明を自動的にプロンプトへ注入します。一致するタスクを認識すると、フルの指示を読み込む前にスキルを有効化してよいか許可を求めます。

### 方法 2: GEMINI.md（永続的なコンテキスト）

オンデマンドでの有効化ではなく、常に永続的なプロジェクトコンテキストとして読み込みたいスキルは、プロジェクトの `GEMINI.md` に追加します:

```bash
# Create GEMINI.md with core skills as persistent context
cat /path/to/agent-skills/skills/incremental-implementation/SKILL.md > GEMINI.md
echo -e "\n---\n" >> GEMINI.md
cat /path/to/agent-skills/skills/code-review-and-quality/SKILL.md >> GEMINI.md
```

別々のファイルからインポートしてモジュール化することもできます:

```markdown
# Project Instructions

@skills/test-driven-development/SKILL.md
@skills/incremental-implementation/SKILL.md
```

読み込まれたコンテキストを確認するには `/memory show` を、変更後に再読み込みするには `/memory reload` を使います。

> **スキルと GEMINI.md の違い:** スキルは関連するときだけ有効化されるオンデマンドの専門知識で、コンテキストウィンドウをきれいに保ちます。GEMINI.md はすべてのプロンプトで読み込まれる永続的なコンテキストを提供します。フェーズ固有のワークフローにはスキルを、常時適用したいプロジェクト規約には GEMINI.md を使いましょう。

## 推奨構成

### 常時オン（GEMINI.md）

これらはすべてのセッションで永続的なコンテキストとして追加します:

- `incremental-implementation` — 小さく検証可能なスライスで構築する
- `code-review-and-quality` — 5観点レビュー

### オンデマンド（スキル）

これらはスキルとしてインストールし、関連するときだけ有効化されるようにします:

- `test-driven-development` — ロジックの実装やバグ修正のときに有効化
- `spec-driven-development` — 新しいプロジェクトや機能を始めるときに有効化
- `frontend-ui-engineering` — UI を構築するときに有効化
- `security-and-hardening` — セキュリティレビューのときに有効化
- `performance-optimization` — パフォーマンス作業のときに有効化

## 高度な構成

### MCP 連携

このパックの多くのスキルは、環境と対話するために [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) ツールを活用します。例えば:

- `browser-testing-with-devtools` は `chrome-devtools` MCP 拡張機能を使います。
- `performance-optimization` はパフォーマンス関連の MCP ツールの恩恵を受けられます。

これらを有効にするには、Gemini CLI の設定（`~/.gemini/config.json`）に該当する MCP 拡張機能がインストールされていることを確認してください。

### セッションフック

Gemini CLI はセッションのライフサイクルフックをサポートしています。これらを使うと、セッション開始時にコンテキストを自動的に注入したり、検証スクリプトを実行したりできます。

他のツールでの `agent-skills` の体験を再現するには、利用可能なスキルを思い出させたり、メタスキルを読み込んだりする `SessionStart` フックを構成できます。

### コンテキストの明示的な読み込み

プロンプト内で `@` 記号を使ってスキルを参照することで、任意のスキルを現在のセッションへ明示的に読み込めます:

```markdown
Use the @skills/test-driven-development/SKILL.md skill to implement this fix.
```

これは、自動検出を待たずに特定のワークフローを確実に踏ませたいときに便利です。

## スラッシュコマンド

このリポジトリは `.gemini/commands/` 配下に 8 つのスラッシュコマンドを同梱しています。7 つのライフサイクルコマンドに加え、`/webperf` の専門監査です。プロジェクトのルートから実行すると、Gemini CLI がこれらを自動検出します。

| コマンド | 機能 |
|---------|--------------|
| `/spec` | コードを書く前に構造化された仕様を書く |
| `/planning` | 作業を小さく検証可能なタスクに分解する |
| `/build` | 次のタスクを段階的に実装する |
| `/test` | TDD ワークフローを実行する — red、green、refactor |
| `/review` | 5観点コードレビュー |
| `/code-simplify` | 挙動を変えずに複雑さを減らす |
| `/ship` | ペルソナへの並列ファンアウトによるリリース前チェックリスト |
| `/webperf` | ブラウザ向けアプリを Core Web Vitals とパフォーマンス問題について監査する |

各コマンドは対応するスキルを自動的に呼び出します。手動でスキルを読み込む必要はありません。

> **注意:** `/plan` ではなく `/planning` を使ってください。`/plan` は Gemini CLI の内部コマンド名と衝突します。

## 使い方のヒント

1. **GEMINI.md よりスキルを優先する** — スキルはオンデマンドで有効化され、コンテキストウィンドウを集中した状態に保ちます。常に読み込んでおきたい場合にのみスキルを GEMINI.md に入れてください。
2. **スキルの説明が重要** — 各 SKILL.md のフロントマターには `description` フィールドがあり、エージェントにいつ有効化すべきかを伝えます。このリポジトリの説明は、スキルが*何を*するのかと*いつ*トリガーされるべきかの両方を明確に示すことで、サポートされるすべてのツール（Claude Code、Gemini CLI など）にわたる自動検出に最適化されています。
3. **レビューにはエージェントを使う** — 構造化されたコードレビューを依頼するときは `agents/code-reviewer.md` の内容をコピーしてください。
4. **リファレンスと組み合わせる** — テストやパフォーマンスといった特定の品質領域に取り組むときは、`references/` のチェックリストを参照してください。
