# 日本語ローカライズの運用メモ

このリポジトリは upstream（[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)）の
日本語ローカライズ・フォークです。**スキル本文・コードは英語のまま**、**インターフェイス（AIの応答）を日本語**にしています。
このファイルは「upstream から最新を取り込むときの手順」と「ローカライズの構成」をまとめたものです。

## ローカライズの構成（2層）

| 層 | 中身 | 置き場所 | upstream との衝突 | 復元方法 |
|---|---|---|---|---|
| ① 機能ローカライズ | 日本語応答ディレクティブ、description への日本語トリガー、gemini コマンドの応答指示 | 英語ファイルに **in-place 追記**（メタスキル・hook・AGENTS.md・各 description・gemini toml） | 低〜中 | `scripts/localize-ja.sh` で**冪等に再生成** |
| ② 文書翻訳 | README / docs / CONTRIBUTING の和訳 | **別ファイル** `*.ja.md`（`README.ja.md`, `docs/*.ja.md`, `CONTRIBUTING.ja.md`） | **なし**（upstream に同名ファイルが無い） | 手動（必要なときだけ） |

- 英語の `README.md` / `docs/*.md` / `CONTRIBUTING.md` は **upstream と同一**に保ち、追従の正本とします。
- 日本語の入口は `README.ja.md`。英語版の冒頭から `README.ja.md` へリンクしています。

## 前提（初回のみ）

```bash
git remote add upstream https://github.com/addyosmani/agent-skills.git   # 登録済みなら不要
```

## 取り込みランブック

```bash
# 1. upstream を取得
git fetch upstream

# 2. 作業ブランチを切る（main 直接マージは避ける）
git switch -c sync/upstream-$(date +%Y%m%d) main

# 3. マージ
git merge upstream/main
#    → 衝突は基本的に「① の in-place 追記箇所」だけ。
#      迷ったら upstream 側を採用してよい（① は次のステップで作り直せる）。
#      ② の *.ja.md は upstream に存在しないので衝突しない。

# 4. ① 機能ローカライズを冪等に再適用（衝突で消えても復元される）
bash scripts/localize-ja.sh

# 5. 検証
node scripts/validate-skills.js
bash hooks/session-start-test.sh

# 6. （任意）upstream で英語ドキュメントが更新されていたら、対応する *.ja.md を訳し直す
#     差分の確認例:
#     git diff ORIG_HEAD..HEAD -- README.md docs/ CONTRIBUTING.md

# 7. コミットして origin へ
git add -A && git commit
git push -u origin HEAD
#    → origin/main へ PR を出してマージ
```

### 衝突解決の指針

- **`description:` 行の衝突**: upstream の英語説明を採用し、日本語トリガーの追記は捨ててよい（手順4で復活する）。
- **メタスキル / `AGENTS.md` / `hooks/session-start.sh`**: upstream を採用してよい（手順4で復活する）。
- **`*.ja.md`**: そもそも衝突しない。英語版が変わった箇所だけ、気が向いたときに訳し直す（手順6）。

## スクリプトが扱う範囲（`scripts/localize-ja.sh`）

冪等（何度実行しても安全）。再適用するのは①のみ：

1. 全スキル / コマンド / エージェント / gemini コマンドの `description` への日本語トリガー
2. `skills/using-agent-skills/SKILL.md` の「Language / 言語」節（毎セッション hook で注入される）
3. `hooks/session-start.sh` の起動メッセージ中の日本語応答指示
4. `AGENTS.md` の「Language / 言語」節
5. `.gemini/commands/*.toml` の日本語トリガー＋応答指示

`*.ja.md`（文書翻訳）は **扱いません**（手動管理）。

## 新しいスキルが upstream に増えたとき

`scripts/localize-ja.sh` の `DESC` マップにそのスキルのパスと日本語トリガーを 1 行追加してください。
追加し忘れても英語のままで動作はします（応答日本語化はメタスキル経由で全体に効くため）。
