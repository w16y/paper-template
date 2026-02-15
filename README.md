# 学術論文執筆テンプレート

MarkdownとPandocを使用した学術論文執筆のためのテンプレートです。

## 特徴

- Markdownで論文を執筆
- PandocによるWord文書出力
- 参考文献管理（YAML形式）
- Dockerによる環境依存なしのビルド

## ディレクトリ構造

```
.
├── template.md         # 論文テンプレート
├── cite.yaml          # 参考文献
├── Makefile           # ビルド自動化
├── config/            # Pandoc設定ファイル
│   ├── _hinagata-horizontal-ja.docx  # Word出力テンプレート
│   ├── _ieee.csl      # IEEE引用スタイル
│   ├── _output.yaml   # 出力設定
│   └── _pagebreak.lua # ページ区切りフィルター
├── output/            # 出力ディレクトリ
└── assets/            # 画像等のリソース
```

## 使い方

### 1. 新しい論文の作成

1. `template.md`をベースに執筆
2. YAMLヘッダー（title, author等）を編集
3. 各セクションに内容を記入

### 2. 論文のビルド（Docker使用）

```bash
# デフォルト（template.md）をビルド
make

# 特定のファイルをビルド
make INPUT=your_paper.md

# タイムスタンプなしでビルド（上書き）
make TIMESTAMP=false INPUT=your_paper.md

# 出力ディレクトリをクリーン
make clean

# ヘルプを表示
make help
```

### 3. 参考文献の管理

`cite.yaml`に参考文献を追加：

```yaml
# 英語著者名: family/given を使用（イニシャルに自動変換される）
- id: smith2024
  type: article-journal
  author:
    - family: Smith
      given: John
  title: "Paper Title"
  container-title: Journal Name
  volume: 1
  page: 1-10
  issued:
    year: 2024

# 日本語著者名: literal を使用（フルネームがそのまま出力される）
- id: yamada2024
  type: article-journal
  author:
    - literal: 山田太郎
  title: "論文タイトル"
  container-title: 情報処理学会論文誌
  volume: 1
  page: 1-10
  issued:
    year: 2024
```

> **注意**: 日本語の著者名には `literal` フィールドを使用してください。`family`/`given` を使うと名前がイニシャルに省略されピリオドが付いてしまいます。

本文中での引用：
```markdown
既存研究では[@smith2024]...
複数の文献[@smith2024; @yamada2024]では...
```

## 必要な環境

- Docker Desktop または Docker Engine
- Make（makeコマンド）
