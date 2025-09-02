# 学術論文執筆テンプレート

MarkdownとPandocを使用した日本語学術論文執筆のためのテンプレートです。

## 特徴

- Markdownで論文を執筆
- PandocによるWord文書出力
- 日本語・英語テンプレート
- 参考文献管理（YAML形式）
- Dockerによる環境依存なしのビルド

## ディレクトリ構造

```
.
├── template.md         # 日本語論文テンプレート（サンプル含む）
├── template_en.md      # 英語論文テンプレート
├── example_paper_en.md # 英語論文の例
├── cite.yaml          # 参考文献データベース
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

1. `template.md`（日本語）または`template_en.md`（英語）をベースに編集
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
- id: author2024
  type: article-journal
  author:
    - family: 著者姓
      given: 著者名
  title: 論文タイトル
  container-title: ジャーナル名
  volume: 1
  issue: 1
  page: 1-10
  issued:
    year: 2024
```

本文中での引用：
```markdown
既存研究では[@author2024]...
```

## 必要な環境

- Docker Desktop または Docker Engine
- Make（makeコマンド）

## カスタマイズ

### 出力フォーマット
`config/_output.yaml`で出力設定を変更可能

### 引用スタイル
`config/_ieee.csl`を他のCSLファイルに置き換えることで引用スタイルを変更可能

### Wordテンプレート
`config/_hinagata-horizontal-ja.docx`を編集してWord出力のスタイルをカスタマイズ
