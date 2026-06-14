> 🇬🇧 English (canonical): [opencode-setup.md](opencode-setup.md)

# OpenCode セットアップ

このガイドでは、Claude Code の体験（自動的なスキル選択、ライフサイクル駆動のワークフロー、厳格なプロセスの徹底）にできる限り近い形で、Agent Skills を OpenCode と組み合わせて使う方法を説明します。

## 概要

OpenCode はカスタムの `/commands` をサポートしていますが、Claude Code のようなネイティブのプラグインシステムや自動的なスキルのルーティングは備えていません。

その代わりに、次の要素を通じて同等の機能を実現します。

- 強力なシステムプロンプト（`AGENTS.md`）
- 組み込みの `skill` ツール
- `/skills` ディレクトリからの一貫したスキルの検出

これにより、スキルが自動的に選択・実行される **エージェント駆動のワークフロー** が生まれます。

OpenCode で `/spec` や `/plan` などのコマンドを再現することも可能ですが、この統合では意図的にエージェント駆動のアプローチを採用しています。

- スキルは意図に基づいて自動的に選択されます
- ワークフローは `AGENTS.md` を通じて徹底されます
- 手動でのコマンド呼び出しは不要です

これは、スキルが手動ではなく自動的にトリガーされるという、実際の Claude Code の挙動により近いものです。

---

## インストール

1. リポジトリをクローンします。

```bash
git clone https://github.com/addyosmani/agent-skills.git
```

2. プロジェクトを OpenCode で開きます。

3. 次のファイルがワークスペースに存在することを確認します。

- `AGENTS.md`（ルート）
- `skills/` ディレクトリ

追加のインストールは不要です。

---

## 仕組み

### 1. スキルの検出

すべてのスキルは次の場所に置かれます。

```
skills/<skill-name>/SKILL.md
```

OpenCode のエージェントは（`AGENTS.md` を通じて）次のように指示されます。

- スキルが適用される場面を検出する
- `skill` ツールを呼び出す
- スキルに正確に従う

### 2. 自動的なスキルの呼び出し

エージェントはすべてのリクエストを評価し、適切なスキルに対応付けます。

例:

- 「機能を作る」 → `incremental-implementation` ＋ `test-driven-development`
- 「システムを設計する」 → `spec-driven-development`
- 「バグを直す」 → `debugging-and-error-recovery`
- 「このコードをレビューする」 → `code-review-and-quality`

ユーザーがスキルを明示的にリクエストする必要は **ありません**。

### 3. ライフサイクルの対応付け（暗黙的なコマンド）

開発のライフサイクルは暗黙的にエンコードされています。

- DEFINE → `spec-driven-development`
- PLAN → `planning-and-task-breakdown`
- BUILD → `incremental-implementation` ＋ `test-driven-development`
- VERIFY → `debugging-and-error-recovery`
- REVIEW → `code-review-and-quality`
- SHIP → `shipping-and-launch`

これにより `/spec` や `/plan` などのスラッシュコマンドが置き換えられます。

---

## 使用例

### 例 1: 機能開発

ユーザー:
```
Add authentication to this app
```

エージェントの挙動:
- 機能開発を検出します
- `spec-driven-development` を呼び出します
- コードを書く前に仕様を作成します
- 計画と実装のスキルへ移行します

---

### 例 2: バグ修正

ユーザー:
```
This endpoint is returning 500 errors
```

エージェントの挙動:
- `debugging-and-error-recovery` を呼び出します
- 再現 → 切り分け → 修正 → ガードの追加 を行います

---

### 例 3: コードレビュー

ユーザー:
```
Review this PR
```

エージェントの挙動:
- `code-review-and-quality` を呼び出します
- 構造化されたレビュー（正確性、設計、可読性など）を適用します

---

## エージェントへの期待（重要）

OpenCode が正しく動作するために、エージェントは次のルールに従う必要があります。

- 行動する前に、常にスキルが適用されるかどうかを確認する
- スキルが適用される場合は、必ずそれを使用しなければならない
- 必須のワークフロー（仕様、計画、テストなど）を決してスキップしない
- 実装に直接飛びつかない

これらのルールは `AGENTS.md` を通じて徹底されます。

---

## 制限事項

- ネイティブのスラッシュコマンドはありません（代わりに意図の対応付けで処理します）
- プラグインシステムはありません（プロンプト＋構造で処理します）
- スキルの呼び出しはモデルの遵守に依存します

これらの制限はあるものの、ワークフローは実際には Claude Code に非常に近いものになります。

---

## 推奨ワークフロー

自然言語をそのまま使ってください。

- 「Design a feature」
- 「Plan this change」
- 「Implement this」
- 「Fix this bug」
- 「Review this」

エージェントが正しいスキルを自動的に選択して実行します。

---

## まとめ

OpenCode の統合は、次の要素を組み合わせることで機能します。

- 構造化されたスキル（このリポジトリ）
- 強力なエージェントのルール（`AGENTS.md`）
- 推論による自動的なスキルの呼び出し

これにより、プラグインや手動のコマンドを必要とせずに、**完全にエージェント駆動で本番品質のエンジニアリングワークフロー** が実現します。
