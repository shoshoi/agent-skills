> 🇬🇧 English (canonical): [skill-anatomy.md](skill-anatomy.md)

# スキルの構造（Skill Anatomy）

このドキュメントでは、agent-skills のスキルファイルの構造と形式について説明します。新しいスキルを追加するときや、既存のスキルを理解するときのガイドとして利用してください。

## ファイルの配置場所

すべてのスキルは、`skills/` 配下にある独自のディレクトリに格納します。

```
skills/
  skill-name/
    SKILL.md           # Required: The skill definition
    scripts/           # Optional: Runnable helpers used by the skill workflow
    supporting-file.md # Optional: Reference material loaded on demand
```

必須のファイルは `SKILL.md` だけです。`scripts/` は、スキルが実際に実行可能なヘルパーを同梱する場合にのみ追加し、Markdown のみで構成されるスキルではこのディレクトリを丸ごと省略してください。

## SKILL.md の形式

### フロントマター（必須）

```yaml
---
name: skill-name-with-hyphens
description: Guides agents through [task/workflow]. Use when [specific trigger conditions].
---
```

**ルール:**
- `name`: 小文字でハイフン区切りにします。ディレクトリ名と一致している必要があります。
- `description`: そのスキルが何をするのかを三人称で書き始め、続けて1つ以上の明確な「Use when（使うとき）」のトリガー条件を含めます。*何を（what）* と *いつ（when）* の両方を含めてください。最大1024文字です。

**なぜ重要なのか:** エージェントは説明（description）を読むことでスキルを発見します。description はシステムプロンプトに注入されるため、そのスキルが何を提供するのか、そしていつ起動すべきなのかの両方をエージェントに伝える必要があります。ワークフローを要約してはいけません。description にプロセスの手順が含まれていると、エージェントはスキル本体を読まずに、その要約に従ってしまうおそれがあります。

### 標準的なセクション（推奨パターン）

上記のフロントマターの取り決めは必須です。以下のセクション構成は推奨パターンであり、厳密なテンプレートではありません。同じ目的を明確に果たすのであれば、同等の見出しを用いても構いません。

```markdown
# Skill Title

## Overview
One-two sentences explaining what this skill does and why it matters.

## When to Use
- Bullet list of triggering conditions (symptoms, task types)
- When NOT to use (exclusions)

## [Core Process / The Workflow / Steps]
The main workflow, broken into numbered steps or phases.
Include code examples where they help.
Use flowcharts (ASCII) where decision points exist.

## [Specific Techniques / Patterns]
Detailed guidance for specific scenarios.
Code examples, templates, configuration.

## Common Rationalizations
| Rationalization | Reality |
|---|---|
| Excuse agents use to skip steps | Why the excuse is wrong |

## Red Flags
- Behavioral patterns indicating the skill is being violated
- Things to watch for during review

## Verification
After completing the skill's process, confirm:
- [ ] Checklist of exit criteria
- [ ] Evidence requirements
```

## 各セクションの目的

### Overview（概要）
スキルの「エレベーターピッチ」です。「このスキルは何をするのか、そしてなぜエージェントはこれに従うべきなのか？」に答えるべきです。

### When to Use（使うとき）
このスキルが現在のタスクに当てはまるかどうかを、エージェントと人間が判断するのに役立ちます。肯定的なトリガー（「Use when X」）と否定的な除外条件（「NOT for Y」）の両方を含めてください。

### Core Process（中心となるプロセス）
スキルの核心です。これはエージェントが従うステップバイステップのワークフローです。曖昧なアドバイスではなく、具体的で実行可能でなければなりません。

**良い例:** 「`npm test` を実行し、すべてのテストが通ることを確認する」
**悪い例:** 「テストが動くことを確かめる」

### Common Rationalizations（よくある合理化（言い訳））
よく練られたスキルの最も特徴的な要素です。これらは、エージェントが重要な手順を飛ばすために使う言い訳と、それに対する反論をセットにしたものです。これにより、エージェントが言い訳を並べてプロセスに従わずに済ませてしまうのを防ぎます。

エージェントが「テストは後で追加します」とか「これは十分に単純なので仕様は飛ばします」と言うたびのことを思い浮かべてください。それらを、事実に基づく反論とともにここに記載します。

### Red Flags（レッドフラグ）
スキルが守られていないことを示す、観察可能な兆候です。コードレビューや自己モニタリングの際に役立ちます。

### Verification（検証）
終了基準です。スキルのプロセスが完了したことをエージェントが確認するために使うチェックリストです。すべてのチェックボックスは、証拠（テスト出力、ビルド結果、スクリーンショットなど）によって検証可能であるべきです。

## 補助ファイル（Supporting Files）

補助ファイルは、次の場合にのみ作成してください。
- 参照用の資料が100行を超える場合（メインの SKILL.md を集中した状態に保つため）
- コードツールやスクリプトが必要な場合
- チェックリストが、別ファイルにするだけの長さになっている場合

50行未満であれば、パターンや原則はインラインのままにしてください。

スキルが実行可能なヘルパーを必要としない場合は、他のスキルに合わせるためだけに空の `scripts/` ディレクトリを作成しないでください。空のディレクトリは、スキルの動作を変えることなくノイズを増やすだけです。

## 執筆の原則

1. **知識よりもプロセス。** スキルはリファレンス資料ではなくワークフローです。事実ではなく手順を書きます。
2. **一般論よりも具体。** 「`npm test` を実行する」は「テストを検証する」に勝ります。
3. **思い込みよりも証拠。** すべての検証チェックボックスには証拠が必要です。
4. **反・合理化（アンチ・ラショナライゼーション）。** 飛ばされかねない手順にはすべて、合理化（言い訳）の表に反論を用意します。
5. **段階的な開示（プログレッシブ・ディスクロージャー）。** メインの SKILL.md が入口です。補助ファイルは必要なときにのみ読み込まれます。
6. **トークンを意識する。** すべてのセクションは、それを含める理由を正当化できなければなりません。それを削除してもエージェントの動作が変わらないのであれば、削除してください。

## 命名規則

- スキルのディレクトリ: `lowercase-hyphen-separated`
- スキルのファイル: `SKILL.md`（常に大文字）
- 補助ファイル: `lowercase-hyphen-separated.md`
- リファレンス: スキルのディレクトリ内ではなく、プロジェクトルートの `references/` に格納します

## スキル間の参照

他のスキルは名前で参照します。

```markdown
Follow the `test-driven-development` skill for writing tests.
If the build breaks, use the `debugging-and-error-recovery` skill.
```

スキル間で内容を重複させず、参照とリンクで対応してください。

## 必須 vs 推奨

必須:

- `skills/<skill-name>/SKILL.md` ファイル
- `name` と `description` を含む、有効な YAML フロントマター
- そのスキルが何をするのか、そしていつ使うのかの両方を含む description

推奨:

- 上記で示した標準的なセクションの流れ
- スキルにとってより自然に読める場合の、`How It Works`、`Core Process`、`Workflow` といった同等の見出し
- メインの `SKILL.md` を集中した状態に保てる場合にのみ用いる補助ファイル
