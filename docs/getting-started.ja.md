> 🇬🇧 English (canonical): [getting-started.md](getting-started.md)

# agent-skills を始める

agent-skills は、Markdown 形式の指示を受け付けるあらゆる AI コーディングエージェントで動作します。本ガイドでは汎用的な方法を説明します。ツール固有のセットアップについては、各専用ガイドを参照してください。

## スキルの仕組み

各スキルは、特定のエンジニアリングワークフローを記述した Markdown ファイル（`SKILL.md`）です。エージェントのコンテキストに読み込まれると、エージェントは検証ステップ、避けるべきアンチパターン、終了条件を含めてそのワークフローに従います。

**スキルはリファレンスドキュメントではありません。** エージェントが従う段階的なプロセスです。

## クイックスタート（任意のエージェント）

### 1. リポジトリをクローンする

```bash
git clone https://github.com/addyosmani/agent-skills.git
```

### 2. スキルを選ぶ

`skills/` ディレクトリを参照してください。各サブディレクトリには、次の内容を含む `SKILL.md` があります。
- **使うとき** — このスキルが該当することを示すトリガー
- **プロセス** — 段階的なワークフロー
- **検証** — 作業が完了したことを確認する方法
- **よくある言い訳** — エージェントがステップを飛ばすために使いがちな言い訳
- **レッドフラグ** — スキルが守られていない兆候

### 3. スキルをエージェントに読み込む

該当する `SKILL.md` の内容を、エージェントのシステムプロンプト、ルールファイル、または会話にコピーします。最も一般的な方法は次のとおりです。

**システムプロンプト:** セッションの開始時にスキルの内容を貼り付けます。

**ルールファイル:** プロジェクトのルールファイル（CLAUDE.md、.cursorrules など）にスキルの内容を追加します。

**会話:** 指示を出す際にスキルを参照します。例: 「この変更には test-driven-development のプロセスに従ってください。」

### 4. 発見のためにメタスキルを使う

`using-agent-skills` スキルを読み込んだ状態から始めてください。これにはタスクの種類を適切なスキルに対応付けるフローチャートが含まれています。

## 推奨セットアップ

### 最小構成（ここから始める）

3 つの必須スキルをルールファイルに読み込みます。

1. **spec-driven-development** — 何を作るかを定義するため
2. **test-driven-development** — それが動作することを証明するため
3. **code-review-and-quality** — マージ前に品質を検証するため

この 3 つが、AI 支援開発における最も重大な品質上のギャップをカバーします。

### フルライフサイクル

包括的にカバーするには、フェーズごとにスキルを読み込みます。

```
Starting a project:  spec-driven-development → planning-and-task-breakdown
During development:  incremental-implementation + test-driven-development
Before merge:        code-review-and-quality + security-and-hardening
Before deploy:       shipping-and-launch
```

### コンテキストに応じた読み込み

すべてのスキルを一度に読み込まないでください。コンテキストの無駄になります。現在のタスクに関連するスキルを読み込みましょう。

- UI の作業中ですか? `frontend-ui-engineering` を読み込みます
- デバッグ中ですか? `debugging-and-error-recovery` を読み込みます
- CI のセットアップ中ですか? `ci-cd-and-automation` を読み込みます

## スキルの構造

すべてのスキルは同じ構造に従います。

```
YAML frontmatter (name, description)
├── Overview — What this skill does
├── When to Use — Triggers and conditions
├── Core Process — Step-by-step workflow
├── Examples — Code samples and patterns
├── Common Rationalizations — Excuses and rebuttals
├── Red Flags — Signs the skill is being violated
└── Verification — Exit criteria checklist
```

完全な仕様については [skill-anatomy.md](skill-anatomy.md) を参照してください。

## エージェントを使う

`agents/` ディレクトリには、事前構成されたエージェントのペルソナが含まれています。

| エージェント | 目的 |
|-------|---------|
| `code-reviewer.md` | 5 観点のコードレビュー |
| `test-engineer.md` | テスト戦略と作成 |
| `security-auditor.md` | 脆弱性の検出 |
| `web-performance-auditor.md` | Core Web Vitals とパフォーマンス監査（`/webperf` 経由） |

専門的なレビューが必要なときにエージェント定義を読み込みます。たとえば、コーディングエージェントに「code-reviewer エージェントのペルソナを使ってこの変更をレビューしてください」と依頼し、エージェント定義を提供します。

## コマンドを使う

`.claude/commands/` ディレクトリには、Claude Code 向けのスラッシュコマンドが含まれています。

| コマンド | 呼び出されるスキル |
|---------|---------------|
| `/spec` | spec-driven-development |
| `/plan` | planning-and-task-breakdown |
| `/build` | incremental-implementation + test-driven-development |
| `/build auto` | planning-and-task-breakdown → incremental-implementation + test-driven-development（計画全体を 1 回の承認で実行） |
| `/test` | test-driven-development |
| `/review` | code-review-and-quality |
| `/code-simplify` | code-simplification |
| `/ship` | shipping-and-launch |
| `/webperf` | web-performance-auditor（専門エージェント、Web アプリ専用） |

## リファレンスを使う

`references/` ディレクトリには、補助的なチェックリストが含まれています。

| リファレンス | 併用するもの |
|-----------|----------|
| `testing-patterns.md` | test-driven-development |
| `performance-checklist.md` | performance-optimization |
| `security-checklist.md` | security-and-hardening |
| `accessibility-checklist.md` | frontend-ui-engineering |

スキルがカバーする範囲を超えた詳細なパターンが必要なときにリファレンスを読み込みます。

## 仕様とタスクの成果物

`/spec` および `/plan` コマンドは、作業用の成果物（`SPEC.md`、`tasks/plan.md`、`tasks/todo.md`）を作成します。作業が進行中の間は、これらを**生きたドキュメント**として扱ってください。

- 開発中はバージョン管理下に置き、人間とエージェントが共有の信頼できる情報源を持てるようにします。
- スコープや決定が変わったら更新します。
- これらのファイルをリポジトリに長期的に残したくない場合は、マージ前に削除するか、フォルダを `.gitignore` に追加してください。ワークフローはこれらが恒久的であることを要求しません。

## ヒント

1. 自明でない作業には、まず **spec-driven-development から始める**
2. コードを書くときは、**常に test-driven-development を読み込む**
3. **検証ステップを飛ばさない** — それこそが要点です
4. **スキルは選んで読み込む** — コンテキストは多ければよいというものではありません
5. **レビューにはエージェントを使う** — 異なる視点が異なる問題を捉えます
