# Agent Skills

**AIコーディングエージェントのための、実戦投入レベルのエンジニアリングスキル集。**

スキルは、シニアエンジニアがソフトウェアを作るときに使うワークフロー・品質ゲート・ベストプラクティスを体系化したものです。ここに収録したスキルは、AIエージェントが開発の全フェーズで一貫してそれらに従えるようパッケージ化されています。

> **言語について:** このフォークはインターフェイス（AIの応答）を日本語に設定しています。スキル本文・コード・識別子は英語のままです。詳しくは [skills/using-agent-skills/SKILL.md](skills/using-agent-skills/SKILL.md) の「Language / 言語」節を参照してください。英語版（upstream 追従の正本）は [README.md](README.md) です。

![Addy's Agent Skills](https://addyosmani.com/assets/images/addys-agent-skills.jpg)

```
  DEFINE          PLAN           BUILD          VERIFY         REVIEW          SHIP
 ┌──────┐      ┌──────┐      ┌──────┐      ┌──────┐      ┌──────┐      ┌──────┐
 │ Idea │ ───▶ │ Spec │ ───▶ │ Code │ ───▶ │ Test │ ───▶ │  QA  │ ───▶ │  Go  │
 │Refine│      │  PRD │      │ Impl │      │Debug │      │ Gate │      │ Live │
 └──────┘      └──────┘      └──────┘      └──────┘      └──────┘      └──────┘
  /spec          /plan          /build        /test         /review       /ship
```

---

## コマンド

開発ライフサイクルに対応する7つのスラッシュコマンドです。それぞれが適切なスキルを自動で起動します。

| やりたいこと | コマンド | 中心となる原則 |
|-------------------|---------|---------------|
| 何を作るかを定義する | `/spec` | コードより先に仕様 |
| 作り方を計画する | `/plan` | 小さく原子的なタスク |
| 段階的に作る | `/build` | 一度に1スライス |
| 動くことを証明する | `/test` | テストは証拠 |
| マージ前にレビューする | `/review` | コードの健全性を高める |
| コードを簡潔にする | `/code-simplify` | 賢さより明快さ |
| 本番へ出荷する | `/ship` | 速いほど安全 |

仕様ができた後、手動ステップを減らしたいときは **`/build auto`** が使えます。計画を生成し、承認済みの1パスで全タスクを実装します。計画を一度承認すれば、あとは自律的に進みます。これはタスク*間*の人手を取り除くだけで、検証は省きません。各タスクは依然としてテスト駆動で、個別にコミットされ、失敗やリスクのあるステップでは停止します。

スキルは、あなたがやっていることに応じて自動でも起動します。API を設計すれば `api-and-interface-design`、UI を作れば `frontend-ui-engineering` が起動する、という具合です。

---

## クイックスタート

<details>
<summary><b>Claude Code（推奨）</b></summary>

**マーケットプレイスからインストール:**

```
/plugin marketplace add addyosmani/agent-skills
/plugin install agent-skills@addy-agent-skills
```

> **SSH エラーが出る場合:** マーケットプレイスは SSH でリポジトリを clone します。GitHub に SSH 鍵を設定していない場合は、[SSH 鍵を追加する](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) か、HTTPS の URL を明示して HTTPS clone を強制してください:
> ```bash
> /plugin marketplace add https://github.com/addyosmani/agent-skills.git
> /plugin install agent-skills@addy-agent-skills
> ```

**ローカル / 開発用:**

```bash
git clone https://github.com/addyosmani/agent-skills.git
claude --plugin-dir /path/to/agent-skills
```

</details>

<details>
<summary><b>Cursor</b></summary>

任意の `SKILL.md` を `.cursor/rules/` にコピーするか、`skills/` ディレクトリ全体を参照します。[docs/cursor-setup.md](docs/cursor-setup.ja.md) を参照してください。

</details>

<details>
<summary><b>Antigravity CLI</b></summary>

スキル・サブエージェント・スラッシュコマンドのネイティブプラグインとしてインストールします。[docs/antigravity-setup.md](docs/antigravity-setup.ja.md) を参照してください。

**リポジトリからインストール:**

```bash
agy plugin install https://github.com/addyosmani/agent-skills.git
```

**ローカルの clone からインストール:**

```bash
git clone https://github.com/addyosmani/agent-skills.git
agy plugin install ./agent-skills
```

</details>

<details>
<summary><b>Gemini CLI</b></summary>

自動検出されるネイティブスキルとしてインストールするか、永続コンテキストとして `GEMINI.md` に追加します。[docs/gemini-cli-setup.md](docs/gemini-cli-setup.ja.md) を参照してください。

**リポジトリからインストール:**

```bash
gemini skills install https://github.com/addyosmani/agent-skills.git --path skills
```

**ローカルの clone からインストール:**

```bash
gemini skills install ./agent-skills/skills/
```

</details>

<details>
<summary><b>Windsurf</b></summary>

スキルの内容を Windsurf のルール設定に追加します。[docs/windsurf-setup.md](docs/windsurf-setup.ja.md) を参照してください。

</details>

<details>
<summary><b>OpenCode</b></summary>

AGENTS.md と `skill` ツールを介した、エージェント駆動のスキル実行を使います。

[docs/opencode-setup.md](docs/opencode-setup.ja.md) を参照してください。

</details>

<details>
<summary><b>GitHub Copilot</b></summary>

`agents/` のエージェント定義を Copilot のペルソナとして、スキルの内容を `.github/copilot-instructions.md` に使います。[docs/copilot-setup.md](docs/copilot-setup.ja.md) を参照してください。

</details>

<details>
  <summary><b>Kiro IDE & CLI </b></summary>
  Kiro 用のスキルは ".kiro/skills/" 配下に置き、プロジェクト単位またはグローバル単位で保存できます。Kiro は Agents.md にも対応しています。Kiro のドキュメント https://kiro.dev/docs/skills/ を参照してください。
</details>

<details>
<summary><b>Codex / その他のエージェント</b></summary>

スキルはプレーンな Markdown なので、システムプロンプトや指示ファイルを受け付けるあらゆるエージェントで動作します。[docs/getting-started.md](docs/getting-started.ja.md) を参照してください。

</details>



---

## 全24スキル

上記のコマンドは入口です。このパックには合計24スキル（23のライフサイクルスキル＋ `using-agent-skills` メタスキル）が含まれます。各スキルは、手順・検証ゲート・合理化対策テーブルを備えた構造化ワークフローです。任意のスキルを直接参照することもできます。

### Meta — どのスキルが該当するかを見極める

| スキル | 何をするか | 使うとき |
|-------|-------------|----------|
| [using-agent-skills](skills/using-agent-skills/SKILL.md) | 受け取った作業を適切なスキルワークフローに割り当て、共通の運用ルールを定義する | セッション開始時、またはどのスキルが該当するか判断するとき |

### Define — 何を作るかを明確にする

| スキル | 何をするか | 使うとき |
|-------|-------------|----------|
| [interview-me](skills/interview-me/SKILL.md) | 1問ずつのインタビューで、ユーザーが「こう言うべき」と思っていることではなく本当に求めているものを、約95%の確信に達するまで引き出す | 依頼が曖昧、またはユーザーが「インタビューして」「詰めて」と呼び出したとき |
| [idea-refine](skills/idea-refine/SKILL.md) | 構造化された発散/収束思考で、曖昧なアイデアを具体的な提案に変える | 探索が必要なざっくりした構想があるとき |
| [spec-driven-development](skills/spec-driven-development/SKILL.md) | コードを書く前に、目的・コマンド・構造・コードスタイル・テスト・境界をカバーする PRD を書く | 新しいプロジェクト・機能・大きな変更を始めるとき |

### Plan — 分解する

| スキル | 何をするか | 使うとき |
|-------|-------------|----------|
| [planning-and-task-breakdown](skills/planning-and-task-breakdown/SKILL.md) | 仕様を、受け入れ基準と依存順序を持つ小さく検証可能なタスクへ分解する | 仕様があり、実装可能な単位が必要なとき |

### Build — コードを書く

| スキル | 何をするか | 使うとき |
|-------|-------------|----------|
| [incremental-implementation](skills/incremental-implementation/SKILL.md) | 薄い縦スライス——実装・テスト・検証・コミット。フィーチャーフラグ、安全なデフォルト、ロールバックしやすい変更 | 2ファイル以上にまたがる変更 |
| [test-driven-development](skills/test-driven-development/SKILL.md) | Red-Green-Refactor、テストピラミッド（80/15/5）、テストサイズ、DRY より DAMP、Beyoncé ルール、ブラウザテスト | ロジックの実装、バグ修正、挙動の変更 |
| [context-engineering](skills/context-engineering/SKILL.md) | 適切な情報を適切なタイミングでエージェントに渡す——ルールファイル、コンテキストの詰め込み、MCP 連携 | セッション開始時、タスク切り替え時、出力品質が落ちたとき |
| [source-driven-development](skills/source-driven-development/SKILL.md) | あらゆるフレームワークの判断を公式ドキュメントに根拠づける——検証し、出典を示し、未検証の点を明示する | フレームワークやライブラリで、出典付きで信頼できるコードが欲しいとき |
| [doubt-driven-development](skills/doubt-driven-development/SKILL.md) | あらゆる非自明な判断を、実行中にフレッシュコンテキストで敵対的レビューする——CLAIM → EXTRACT → DOUBT → RECONCILE → STOP、必要に応じてユーザー承認のうえモデル横断のエスカレーション | 失敗の代償が大きい（本番・セキュリティ・不可逆）、不慣れなコード、または自信のある出力を後でデバッグするより今検証する方が安いとき |
| [frontend-ui-engineering](skills/frontend-ui-engineering/SKILL.md) | コンポーネント設計、デザインシステム、状態管理、レスポンシブデザイン、WCAG 2.1 AA アクセシビリティ | ユーザー向けインターフェイスの構築・変更 |
| [api-and-interface-design](skills/api-and-interface-design/SKILL.md) | 契約ファースト設計、Hyrum の法則、One-Version ルール、エラーセマンティクス、境界バリデーション | API・モジュール境界・公開インターフェイスの設計 |

### Verify — 動くことを証明する

| スキル | 何をするか | 使うとき |
|-------|-------------|----------|
| [browser-testing-with-devtools](skills/browser-testing-with-devtools/SKILL.md) | ライブのランタイムデータを得る Chrome DevTools MCP——DOM 検査、コンソールログ、ネットワークトレース、パフォーマンスプロファイリング | ブラウザで動くものの構築・デバッグ |
| [debugging-and-error-recovery](skills/debugging-and-error-recovery/SKILL.md) | 5ステップのトリアージ：再現・特定・縮小・修正・防御。ストップ・ザ・ライン原則、安全なフォールバック | テストが落ちる、ビルドが壊れる、挙動が想定外のとき |

### Review — マージ前の品質ゲート

| スキル | 何をするか | 使うとき |
|-------|-------------|----------|
| [code-review-and-quality](skills/code-review-and-quality/SKILL.md) | 5観点レビュー、変更サイズ管理（約100行）、重大度ラベル（Nit/Optional/FYI）、レビュー速度の規範、分割戦略 | あらゆる変更のマージ前 |
| [code-simplification](skills/code-simplification/SKILL.md) | チェスタートンの柵、500 の法則、挙動を厳密に保ったまま複雑さを減らす | 動くが、本来あるべきより読みにくい・保守しにくいコード |
| [security-and-hardening](skills/security-and-hardening/SKILL.md) | OWASP Top 10 対策、認証パターン、シークレット管理、依存関係の監査、3層境界システム | ユーザー入力・認証・データ保管・外部連携を扱うとき |
| [performance-optimization](skills/performance-optimization/SKILL.md) | 計測ファーストのアプローチ——Core Web Vitals 目標、プロファイリング手順、バンドル解析、アンチパターン検出 | パフォーマンス要件がある、または劣化が疑われるとき |

### Ship — 自信を持ってデプロイする

| スキル | 何をするか | 使うとき |
|-------|-------------|----------|
| [git-workflow-and-versioning](skills/git-workflow-and-versioning/SKILL.md) | トランクベース開発、原子的コミット、変更サイズ管理（約100行）、コミット＝セーブポイントのパターン | あらゆるコード変更（常に） |
| [ci-cd-and-automation](skills/ci-cd-and-automation/SKILL.md) | シフトレフト、速いほど安全、フィーチャーフラグ、品質ゲートのパイプライン、失敗のフィードバックループ | ビルド・デプロイのパイプラインの構築・変更 |
| [deprecation-and-migration](skills/deprecation-and-migration/SKILL.md) | コードは負債という考え方、強制的廃止と推奨的廃止、移行パターン、ゾンビコードの除去 | 旧システムの撤去、ユーザー移行、機能のサンセット |
| [documentation-and-adrs](skills/documentation-and-adrs/SKILL.md) | アーキテクチャ決定記録（ADR）、API ドキュメント、インラインドキュメントの基準——*なぜ*を記録する | アーキテクチャ判断、API 変更、機能の出荷 |
| [observability-and-instrumentation](skills/observability-and-instrumentation/SKILL.md) | 構造化ログ、RED メトリクス、OpenTelemetry トレーシング、症状ベースのアラート——作りながら計装する | テレメトリの追加、または本番で動くものの出荷 |
| [shipping-and-launch](skills/shipping-and-launch/SKILL.md) | リリース前チェックリスト、フィーチャーフラグのライフサイクル、段階的ロールアウト、ロールバック手順、監視のセットアップ | 本番へのデプロイ準備 |

---

## エージェントペルソナ

狙いを絞ったレビューのための、事前設定済みの専門ペルソナです:

| エージェント | 役割 | 視点 |
|-------|------|-------------|
| [code-reviewer](agents/code-reviewer.md) | シニアスタッフエンジニア | 「スタッフエンジニアがこれを承認するか？」を基準にした5観点コードレビュー |
| [test-engineer](agents/test-engineer.md) | QA スペシャリスト | テスト戦略、カバレッジ分析、Prove-It パターン |
| [security-auditor](agents/security-auditor.md) | セキュリティエンジニア | 脆弱性検出、脅威モデリング、OWASP 評価 |
| [web-performance-auditor](agents/web-performance-auditor.md) | Web パフォーマンスエンジニア | Quick/Deep モードとメトリクス誠実ルールを備えた Core Web Vitals 監査。`/webperf` から実行 |

---

## リファレンスチェックリスト

スキルが必要に応じて参照する、クイックリファレンス資料です:

| リファレンス | カバー範囲 |
|-----------|--------|
| [testing-patterns.md](references/testing-patterns.md) | テスト構造、命名、モック、React/API/E2E の例、アンチパターン |
| [security-checklist.md](references/security-checklist.md) | コミット前チェック、認証、入力バリデーション、ヘッダー、CORS、OWASP Top 10 |
| [performance-checklist.md](references/performance-checklist.md) | Core Web Vitals 目標、フロント/バックエンドのチェックリスト、計測コマンド |
| [accessibility-checklist.md](references/accessibility-checklist.md) | キーボード操作、スクリーンリーダー、ビジュアルデザイン、ARIA、テストツール |

---

## スキルの仕組み

すべてのスキルは一貫した構造（アナトミー）に従います:

```
┌─────────────────────────────────────────────────┐
│  SKILL.md                                       │
│                                                 │
│  ┌─ Frontmatter ─────────────────────────────┐  │
│  │ name: lowercase-hyphen-name               │  │
│  │ description: Guides agents through [task].│  │
│  │              Use when…                    │  │
│  └───────────────────────────────────────────┘  │                                                                                                
│  Overview         → このスキルが何をするか      │
│  When to Use      → 起動条件                    │
│  Process          → ステップごとのワークフロー  │
│  Rationalizations → 言い訳と反論                │
│  Red Flags        → 何かがおかしい兆候          │
│  Verification     → 証拠の要件                  │
└─────────────────────────────────────────────────┘
```

**設計上の重要な選択:**

- **散文ではなくプロセス。** スキルは、エージェントが読む参考資料ではなく、従うワークフローです。各々に手順・チェックポイント・終了基準があります。
- **合理化対策。** すべてのスキルに、ステップを飛ばすためにエージェントが使いがちな言い訳（例:「テストは後で足す」）と、その反証を文書化したテーブルが含まれます。
- **検証は譲れない。** すべてのスキルは証拠の要件で締めくくられます——テスト合格、ビルド出力、ランタイムデータ。「正しそう」では決して不十分です。
- **段階的開示。** `SKILL.md` が入口です。補助リファレンスは必要なときだけ読み込まれ、トークン使用量を最小に保ちます。

---

## プロジェクト構成

```
agent-skills/
├── skills/                            # 24スキル（ライフサイクル23 + メタ1）
│   ├── interview-me/                  #   Define
│   ├── idea-refine/                   #   Define
│   ├── spec-driven-development/       #   Define
│   ├── planning-and-task-breakdown/   #   Plan
│   ├── incremental-implementation/    #   Build
│   ├── context-engineering/           #   Build
│   ├── source-driven-development/     #   Build
│   ├── doubt-driven-development/      #   Build
│   ├── frontend-ui-engineering/       #   Build
│   ├── test-driven-development/       #   Build
│   ├── api-and-interface-design/      #   Build
│   ├── browser-testing-with-devtools/ #   Verify
│   ├── debugging-and-error-recovery/  #   Verify
│   ├── code-review-and-quality/       #   Review
│   ├── code-simplification/          #   Review
│   ├── security-and-hardening/        #   Review
│   ├── performance-optimization/      #   Review
│   ├── git-workflow-and-versioning/   #   Ship
│   ├── ci-cd-and-automation/          #   Ship
│   ├── deprecation-and-migration/     #   Ship
│   ├── documentation-and-adrs/        #   Ship
│   ├── observability-and-instrumentation/ # Ship
│   ├── shipping-and-launch/           #   Ship
│   └── using-agent-skills/            #   Meta: このパックの使い方
├── agents/                            # 4つの専門ペルソナ
├── references/                        # 4つの補助チェックリスト
├── hooks/                             # セッションライフサイクルフック
├── .claude/commands/                  # 7つのスラッシュコマンド（Claude Code）
├── .gemini/commands/                  # 7つのスラッシュコマンド（Gemini CLI）
├── commands/                          # 8つのスラッシュコマンド（Antigravity CLI）
├── plugin.json                        # Antigravity プラグインマニフェスト
└── docs/                              # ツールごとのセットアップガイド
```

---

## なぜ Agent Skills なのか？

AIコーディングエージェントは、既定で最短経路を選びがちです——それはしばしば、仕様・テスト・セキュリティレビュー、そしてソフトウェアを信頼できるものにする実践を飛ばすことを意味します。Agent Skills は、シニアエンジニアが本番コードに持ち込むのと同じ規律を徹底させる、構造化されたワークフローをエージェントに与えます。

各スキルには、苦労して得たエンジニアリング判断が体系化されています——*いつ*仕様を書くか、*何を*テストするか、*どう*レビューするか、*いつ*出荷するか。これらは汎用的なプロンプトではなく、本番品質の仕事をプロトタイプ品質の仕事から分ける、意見を持った、プロセス駆動のワークフローです。

スキルには Google のエンジニアリング文化のベストプラクティスが組み込まれています——[Software Engineering at Google](https://abseil.io/resources/swe-book) の概念や Google の[エンジニアリングプラクティスガイド](https://google.github.io/eng-practices/)を含みます。API 設計には Hyrum の法則、テストには Beyoncé ルールとテストピラミッド、コードレビューには変更サイズ管理とレビュー速度の規範、簡素化にはチェスタートンの柵、git ワークフローにはトランクベース開発、CI/CD にはシフトレフトとフィーチャーフラグ、そしてコードを負債として扱う専用の廃止スキルが見つかります。これらは抽象的な原則ではなく、エージェントが従うステップごとのワークフローに直接埋め込まれています。

---

## コントリビュート

スキルは **具体的**（曖昧な助言ではなく実行可能な手順）、**検証可能**（証拠要件を伴う明確な終了基準）、**実戦で鍛えられた**（実際のワークフローに基づく）、**最小限**（エージェントを導くのに必要なものだけ）であるべきです。

フォーマット仕様は [docs/skill-anatomy.md](docs/skill-anatomy.ja.md) を、ガイドラインは [CONTRIBUTING.md](CONTRIBUTING.ja.md) を参照してください。

---

## ライセンス

MIT - これらのスキルを、あなたのプロジェクト・チーム・ツールで自由に使ってください。
