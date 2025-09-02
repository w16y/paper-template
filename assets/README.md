# Assets Directory

このディレクトリには論文で使用する画像やその他のリソースファイルを配置します。

## 画像の使用方法

Markdownファイル内で以下のように画像を参照できます：

```markdown
![キャプション](assets/filename.png)
```

幅を指定する場合：
```markdown
![キャプション](assets/filename.png){width=80%}
```

図番号を付ける場合：
```markdown
![キャプション](assets/filename.png){#fig:label}
```

## サポートされる形式

- PNG
- JPEG/JPG
- SVG
- PDF（LaTeX出力の場合）

## 推奨事項

- 画像は適切な解像度（印刷用は300dpi以上）で保存
- ファイル名は分かりやすく、スペースを含まない名前を使用
- ベクター画像（SVG）の使用を推奨（拡大しても品質が劣化しない）