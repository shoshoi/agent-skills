> 🇬🇧 English (canonical): [windsurf-setup.md](windsurf-setup.md)

# Windsurf で agent-skills を使う

## セットアップ

### プロジェクトルール

Windsurf はプロジェクト固有のエージェント指示に `.windsurfrules` を使用します。

```bash
# Create a combined rules file from your most important skills
cat /path/to/agent-skills/skills/test-driven-development/SKILL.md > .windsurfrules
echo "\n---\n" >> .windsurfrules
cat /path/to/agent-skills/skills/incremental-implementation/SKILL.md >> .windsurfrules
echo "\n---\n" >> .windsurfrules
cat /path/to/agent-skills/skills/code-review-and-quality/SKILL.md >> .windsurfrules
```

### グローバルルール

すべてのプロジェクトで使いたいスキルは、Windsurf のグローバルルールに追加します。

1. Windsurf → Settings → AI → Global Rules を開きます
2. 最もよく使うスキルの内容を貼り付けます

## 推奨構成

コンテキストの上限内に収めるため、`.windsurfrules` は 2〜3 個の必須スキルに絞っておきます。

```
# .windsurfrules
# Essential agent-skills for this project

[Paste test-driven-development SKILL.md]

---

[Paste incremental-implementation SKILL.md]

---

[Paste code-review-and-quality SKILL.md]
```

## 使い方のヒント

1. **取捨選択する** — Windsurf のコンテキストは限られています。最も大きな品質上の課題に対処するスキルを選びましょう。
2. **会話の中で参照する** — 特定のフェーズに取り組むときは、追加のスキル内容をチャットに貼り付けます（例: 認証機能を構築するときは `security-and-hardening` を貼り付ける）。
3. **リファレンスをチェックリストとして使う** — `references/security-checklist.md` を貼り付けて、各項目を検証するよう Windsurf に依頼します。
