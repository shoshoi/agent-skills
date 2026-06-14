> 🇬🇧 English (canonical): [antigravity-setup.md](antigravity-setup.md)

# Antigravity CLI（agy）で agent-skills を使う

`agent-skills` パッケージは Antigravity CLI（`agy`）にネイティブプラグインとしてインストールでき、エージェントに構造化されたワークフロー、ペルソナ、カスタムスラッシュコマンドへのアクセスを提供します。

## セットアップ

### オプション 1: ネイティブプラグインのインストール（推奨）

Antigravity CLI には、スキル、エージェント、カスタムコマンドを登録できる第一級のプラグインシステムがあります。

**リモートリポジトリからインストールする場合:**

```bash
agy plugin install https://github.com/addyosmani/agent-skills.git
```

**ローカルのクローンからインストールする場合:**

1. リポジトリをクローンします:
   ```bash
   git clone https://github.com/addyosmani/agent-skills.git
   ```
2. `agy` を使ってプラグインをインストールします:
   ```bash
   agy plugin install /path/to/agent-skills
   ```

これにより、プラグインが検証され、グローバルな Antigravity 設定ディレクトリ（`~/.gemini/antigravity-cli/plugins/agent-skills/`）にインストールされます。

### オプション 2: Gemini CLI からインポート

レガシーの Gemini CLI インストールにすでに `agent-skills` をインストールしている場合は、直接インポートできます:
```bash
agy plugin import gemini
```

インストールが完了したら、アクティブなプラグインを確認します:
```bash
agy plugin list
```

---

## スラッシュコマンド

このプラグインは 8 個のカスタムスラッシュコマンドを登録します。7 個のライフサイクルコマンドに加えて、`/webperf` の専門監査コマンドです:

| コマンド | 機能 | 起動されるスキル |
|---------|--------------|-----------------|
| `/spec` | コードを書く前に構造化された仕様を書く | `spec-driven-development` |
| `/planning` | 作業を小さく検証可能なタスクに分解する | `planning-and-task-breakdown` |
| `/build` | 次のタスクを段階的に実装する | `incremental-implementation` |
| `/test` | TDD ワークフロー（レッド、グリーン、リファクタリング）を実行する | `test-driven-development` |
| `/review` | 5観点のコードレビュー | `code-review-and-quality` |
| `/code-simplify` | 挙動を変えずに複雑さを減らす | `code-simplification` |
| `/ship` | ペルソナへの並列ファンアウトによるリリース前チェックリスト | `shipping-and-launch` |
| `/webperf` | ブラウザ向けアプリの Core Web Vitals とパフォーマンス問題を監査する | `web-performance-auditor` |

各コマンドは対応するスキルを自動的に呼び出し、エージェントをステップごとにガイドします。

> **注:** Antigravity の内部のプラン生成コマンドとの競合を避けるため、`/plan` ではなく `/planning` を使用してください。

---

## スキルと検出

Antigravity は、プラグインの `skills/` ディレクトリ内にあるスキルを自動的に検出します。
* Antigravity は、ユーザーのタスクや意図を関連するスキルにオンデマンドで照合します。
* タスクがスキルに一致すると、エージェントはそのスキルを読み込み、実行する前に許可を求めます。

---

## 検証とバリデーション

ローカルのプラグインが正しく構成され、すべてのスキルを含んでいることを検証するには、次を実行します:
```bash
agy plugin validate /path/to/agent-skills
```

---

## 仕組み

### 1. オンデマンドのスキル起動
Antigravity CLI は、インストールされたプラグインの `skills/` ディレクトリにある `SKILL.md` ファイルを自動的に検出します。各スキルのフロントマターにあるトリガーの記述を使って、エージェントは一致する開発者の意図を検出すると、適切なワークフローを動的に起動します。

例えば、エージェントに次のように依頼すると:
- **新しいシステムを設計する** &rarr; `spec-driven-development` を提案・起動します。
- **機能を実装する** &rarr; `incremental-implementation` と `test-driven-development` を起動します。
- **バグを修正する** &rarr; `debugging-and-error-recovery` を起動します。

### 2. 専門のエージェントペルソナ
このプラグインは、`agents/` ディレクトリから再利用可能なサブエージェント定義を登録します:
- `code-reviewer.md`
- `security-auditor.md`
- `test-engineer.md`

これらのペルソナは、セッション内で直接呼び出すことも、サブエージェントを使ってタスクを委譲する際に呼び出すこともできます。

---

## 構成とカスタマイズ

### プロジェクト固有の強制（`AGENTS.md`）
厳格なスキル遵守（例: コードを書く前に仕様やプランを必須とする）を強制するには、`AGENTS.md` をワークスペースのルートにコピーまたはリンクしてください。Antigravity CLI はこのファイルを読み取り、エージェントの挙動とプランニングフェーズをチームの慣習に合わせます。

### サンドボックスモード
限定的なターミナル権限でスキルやスクリプトを実行したい場合（サードパーティの検証テストを実行する際の安全性のため）は、次のように CLI を起動します:

```bash
agy --sandbox
```

---

## 利用のヒント

1. **プラグインを最新に保つ:** 次のコマンドで CLI を更新したり、新しいプラグインのバージョンを確認したりできます:
   ```bash
   agy update
   ```
2. **実行前にレビューする:** エージェントがこれらのスキルを使って複雑なリファクタリングタスクを実行する際は、`Ctrl+r` を使って **Artifact Review** 画面に入り、コードがコミットされる前にレビュー、編集、承認できます。
3. **権限を制御する:** `--dangerously-skip-permissions` フラグは、手動のツール承認プロンプトをバイパスしたい信頼できるローカルプロジェクトでのみ使用できます。
