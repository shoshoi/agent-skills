#!/bin/bash
# localize-ja.sh — Re-apply the Japanese *interface* localization (idempotent).
#
# This script reproduces the mechanical parts of the JA localization so that
# after merging upstream you can restore them with one command instead of
# resolving conflicts by hand. It covers:
#   (1) Japanese trigger phrases appended to every skill/command/agent/gemini
#       `description` field
#   (2) the "Language / 言語" directive in the using-agent-skills meta-skill
#   (3) the Japanese line in the session-start hook message
#   (4) the "Language / 言語" section in AGENTS.md
#   (5) the JA trigger + response directive in .gemini/commands/*.toml
#
# It does NOT touch the prose translations (README.ja.md, docs/*.ja.md,
# CONTRIBUTING.ja.md) — those are manual files that never collide with upstream.
#
# Idempotent: safe to run repeatedly. Re-run after every `git merge upstream/main`.
#
# Usage:  bash scripts/localize-ja.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$REPO_ROOT"

command -v node >/dev/null 2>&1 || { echo "node is required" >&2; exit 1; }

node <<'NODE'
const fs = require("fs");

const MARK = "日本語トリガー:";       // skills / commands / gemini
const MARK_AG = "日本語での起動例:";   // agents

// (1) description triggers ---------------------------------------------------
const DESC = {
 // skills
 "skills/api-and-interface-design/SKILL.md": "日本語トリガー: 「API設計」「インターフェイス設計」「エンドポイント設計」「型契約」「モジュール境界」「フロントとバックの境界」などの依頼時。",
 "skills/browser-testing-with-devtools/SKILL.md": "日本語トリガー: 「ブラウザでテスト」「DevToolsで確認」「DOM検査」「コンソールエラー」「ネットワーク確認」「表示を確認して」などの依頼時。",
 "skills/ci-cd-and-automation/SKILL.md": "日本語トリガー: 「CI/CD構築」「パイプライン設定」「自動デプロイ」「品質ゲート」「CIにテストを組み込む」などの依頼時。",
 "skills/code-review-and-quality/SKILL.md": "日本語トリガー: 「コードレビュー」「マージ前レビュー」「品質チェック」「PRを見て」などの依頼時。",
 "skills/code-simplification/SKILL.md": "日本語トリガー: 「コードを簡潔に」「リファクタリング」「複雑さを減らす」「読みやすくして」などの依頼時。",
 "skills/context-engineering/SKILL.md": "日本語トリガー: 「コンテキスト設定」「ルールファイル整備」「セッション開始」「出力品質が落ちた」などの依頼時。",
 "skills/debugging-and-error-recovery/SKILL.md": "日本語トリガー: 「デバッグ」「エラー解決」「テストが落ちる」「ビルドが壊れた」「原因を調べて」などの依頼時。",
 "skills/deprecation-and-migration/SKILL.md": "日本語トリガー: 「廃止」「移行」「マイグレーション」「旧システム削除」「サンセット判断」などの依頼時。",
 "skills/documentation-and-adrs/SKILL.md": "日本語トリガー: 「ドキュメント作成」「ADR」「設計判断の記録」「意思決定を残す」などの依頼時。",
 "skills/doubt-driven-development/SKILL.md": "日本語トリガー: 「敵対的レビュー」「本当に正しいか確認」「ダブルチェック」「これで合ってる？」などの依頼時。",
 "skills/frontend-ui-engineering/SKILL.md": "日本語トリガー: 「UI構築」「画面実装」「コンポーネント作成」「フロントエンド」「見栄えよく」などの依頼時。",
 "skills/git-workflow-and-versioning/SKILL.md": "日本語トリガー: 「git運用」「コミット」「ブランチ」「コンフリクト解決」「バージョニング」などの依頼時。",
 "skills/idea-refine/SKILL.md": "日本語トリガー: 「アイデアを練る」「発想」「企画をブラッシュアップ」「前提を検証」「案を広げて」などの依頼時。",
 "skills/incremental-implementation/SKILL.md": "日本語トリガー: 「少しずつ実装」「段階的に実装」「インクリメンタルに」「大きい変更を分けて」などの依頼時。",
 "skills/interview-me/SKILL.md": "日本語トリガー: 「インタビューして」「要件を引き出して」「深掘りして」「本当にこれでいい？」「考えを詰めて」などの依頼時。",
 "skills/observability-and-instrumentation/SKILL.md": "日本語トリガー: 「ログ追加」「メトリクス」「トレーシング」「監視」「可観測性」「本番で何が起きたか」などの依頼時。",
 "skills/performance-optimization/SKILL.md": "日本語トリガー: 「パフォーマンス改善」「速度最適化」「Core Web Vitals」「遅い」「ボトルネック」などの依頼時。",
 "skills/planning-and-task-breakdown/SKILL.md": "日本語トリガー: 「計画を立てて」「タスク分解」「作業を分割」「スコープ見積もり」などの依頼時。",
 "skills/security-and-hardening/SKILL.md": "日本語トリガー: 「セキュリティ対策」「脆弱性対策」「ハードニング」「認証」「入力検証」などの依頼時。",
 "skills/shipping-and-launch/SKILL.md": "日本語トリガー: 「リリース準備」「本番デプロイ」「ローンチ」「リリース前チェック」「ロールバック」などの依頼時。",
 "skills/source-driven-development/SKILL.md": "日本語トリガー: 「公式ドキュメントに基づいて」「一次情報で実装」「ソース準拠」「正確に実装」などの依頼時。",
 "skills/spec-driven-development/SKILL.md": "日本語トリガー: 「仕様を作る」「スペック」「設計書を書く」「要件定義」「仕様駆動」などの依頼時。",
 "skills/test-driven-development/SKILL.md": "日本語トリガー: 「TDD」「テスト駆動」「テストを先に書く」「バグ修正」「テストで保証」などの依頼時。",
 "skills/using-agent-skills/SKILL.md": "日本語トリガー: 「スキルを探す」「どのスキルを使う」「セッション開始時」などの場面。",
 // commands
 ".claude/commands/build.md": "日本語トリガー: 「実装して」「段階的にビルド」「タスクを進めて」。",
 ".claude/commands/code-simplify.md": "日本語トリガー: 「コードを簡潔に」「リファクタリング」「読みやすくして」。",
 ".claude/commands/plan.md": "日本語トリガー: 「計画を立てて」「タスク分解」「作業を分けて」。",
 ".claude/commands/review.md": "日本語トリガー: 「コードレビュー」「5観点でレビュー」「PRを見て」。",
 ".claude/commands/ship.md": "日本語トリガー: 「リリース前チェック」「ローンチ判定」「出荷可否」。",
 ".claude/commands/spec.md": "日本語トリガー: 「仕様を作る」「スペック駆動」「設計書から始めて」。",
 ".claude/commands/test.md": "日本語トリガー: 「TDD」「テストを書いて」「テスト駆動で」。",
 ".claude/commands/webperf.md": "日本語トリガー: 「Web性能監査」「パフォーマンス監査」「表示速度を診て」。",
 // agents (different marker phrasing)
 "agents/code-reviewer.md": "日本語での起動例: 「コードレビューして」「マージ前レビュー」「5観点でレビュー」。",
 "agents/security-auditor.md": "日本語での起動例: 「セキュリティ監査」「脆弱性診断」「脅威モデリング」「ハードニング提案」。",
 "agents/test-engineer.md": "日本語での起動例: 「テスト戦略を立てて」「テストを書いて」「カバレッジ分析」。",
 "agents/web-performance-auditor.md": "日本語での起動例: 「Web性能監査」「Core Web Vitals分析」「表示パフォーマンスを診て」。",
};

let descChanged = 0, descSkipped = 0;
for (const [path, suffix] of Object.entries(DESC)) {
  if (!fs.existsSync(path)) { console.warn("WARN missing:", path); continue; }
  const lines = fs.readFileSync(path, "utf8").split("\n");
  let fm = 0, done = false;
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].trim() === "---") { fm++; if (fm === 2) break; continue; }
    if (fm === 1 && lines[i].startsWith("description:")) {
      if (lines[i].includes(MARK) || lines[i].includes(MARK_AG)) { descSkipped++; done = true; break; }
      lines[i] = lines[i].replace(/\s+$/, "") + " " + suffix;
      fs.writeFileSync(path, lines.join("\n"));
      descChanged++; done = true; break;
    }
  }
  if (!done) console.warn("WARN no description line:", path);
}

// (2) meta-skill Language section -------------------------------------------
const META = "skills/using-agent-skills/SKILL.md";
const LANG_META = `## Language / 言語

**Respond to the user in Japanese (日本語) by default.** This is the interface language for this skill collection: all user-facing output — explanations, questions, summaries, status updates, and confirmations — must be written in Japanese, regardless of the language the user writes in. The skill content, code, identifiers, file paths, and commit messages stay in their original language (English where it already is). If the user explicitly asks for another language, follow that request for the rest of the session.

このスキル群のインターフェイス言語は日本語です。ユーザー向けの出力（説明・質問・要約・進捗・確認）は、ユーザーが何語で書いていても既定で日本語にします。スキル本文・コード・識別子・パス・コミットメッセージは元の言語のままで構いません。ユーザーが明示的に他言語を希望した場合はそれに従います。

`;
let metaChanged = false;
if (fs.existsSync(META)) {
  let s = fs.readFileSync(META, "utf8");
  if (!s.includes("## Language / 言語")) {
    if (s.includes("# Using Agent Skills")) {
      s = s.replace("# Using Agent Skills\n", "# Using Agent Skills\n\n" + LANG_META.trimEnd() + "\n");
    }
    fs.writeFileSync(META, s);
    metaChanged = true;
  }
}

// (3) session-start hook message --------------------------------------------
const HOOK = "hooks/session-start.sh";
let hookChanged = false;
if (fs.existsSync(HOOK)) {
  let s = fs.readFileSync(HOOK, "utf8");
  const orig = "agent-skills loaded. Use the skill discovery flowchart";
  const ja = "agent-skills loaded. Respond to the user in Japanese (日本語) by default — see the Language / 言語 section below. Use the skill discovery flowchart";
  if (s.includes(orig) && !s.includes("Respond to the user in Japanese")) {
    s = s.replace(orig, ja);
    fs.writeFileSync(HOOK, s);
    hookChanged = true;
  }
}

// (4) AGENTS.md Language section ---------------------------------------------
const AGENTS = "AGENTS.md";
let agentsChanged = false;
if (fs.existsSync(AGENTS)) {
  let s = fs.readFileSync(AGENTS, "utf8");
  if (!s.includes("## Language / 言語")) {
    const anchor = "## Repository Overview";
    const lang =
      "## Language / 言語\n\n" +
      "**Respond to the user in Japanese (日本語) by default.** All user-facing output " +
      "(explanations, questions, summaries, status updates, confirmations) must be in Japanese, " +
      "regardless of the language the user writes in. Skill content, code, identifiers, paths, and " +
      "commit messages stay in their original language. If the user explicitly requests another " +
      "language, follow that for the rest of the session.\n\n" +
      "ユーザー向けの出力は既定で日本語にします。スキル本文・コード・識別子・パス・コミットメッセージは元の言語のままで構いません。" +
      "ユーザーが明示的に他言語を希望した場合はそれに従います。\n\n";
    if (s.includes(anchor)) {
      s = s.replace(anchor, lang + anchor);
      fs.writeFileSync(AGENTS, s);
      agentsChanged = true;
    }
  }
}

// (5) .gemini/commands/*.toml -----------------------------------------------
const GEMINI = {
 "build.toml": "「実装して」「段階的にビルド」「タスクを進めて」",
 "code-simplify.toml": "「コードを簡潔に」「リファクタリング」「読みやすくして」",
 "planning.toml": "「計画を立てて」「タスク分解」「作業を分けて」",
 "review.toml": "「コードレビュー」「5観点でレビュー」「PRを見て」",
 "ship.toml": "「リリース前チェック」「ローンチ判定」「出荷可否」",
 "spec.toml": "「仕様を作る」「スペック駆動」「設計書から始めて」",
 "test.toml": "「TDD」「テストを書いて」「テスト駆動で」",
 "webperf.toml": "「Web性能監査」「パフォーマンス監査」「表示速度を診て」",
};
const DIRECTIVE = "ユーザーには日本語で応答してください（コードや識別子は元の言語のまま）。\n\n";
let gemChanged = 0;
for (const [name, trig] of Object.entries(GEMINI)) {
  const fp = ".gemini/commands/" + name;
  if (!fs.existsSync(fp)) continue;
  let t = fs.readFileSync(fp, "utf8");
  let changed = false;
  if (!t.includes(MARK)) {
    const t2 = t.replace(/description = "([\s\S]*?)"/, (m, inner) =>
      `description = "${inner} 日本語トリガー: ${trig}などの依頼時。"`);
    if (t2 !== t) { t = t2; changed = true; }
  }
  if (!t.includes("ユーザーには日本語で応答")) {
    const t2 = t.replace(/prompt = """\n?/, 'prompt = """\n' + DIRECTIVE);
    if (t2 !== t) { t = t2; changed = true; }
  }
  if (changed) { fs.writeFileSync(fp, t); gemChanged++; }
}

console.log(`descriptions: ${descChanged} applied, ${descSkipped} already present`);
console.log(`meta-skill Language section: ${metaChanged ? "applied" : "present"}`);
console.log(`session-start hook line:    ${hookChanged ? "applied" : "present"}`);
console.log(`AGENTS.md Language section:  ${agentsChanged ? "applied" : "present"}`);
console.log(`gemini toml: ${gemChanged} updated`);
console.log("localize-ja: done");
NODE
