-- ページ設定（文字数・行数）を強制的に適用するフィルター
-- YAMLメタデータから設定を読み取る
--
-- 使い方:
-- ---
-- page-settings:
--   chars: 40
--   lines: 30
-- ---

-- デフォルト値
local chars_per_line = 40
local lines_per_page = 30
local char_space = 2242  -- 文字数40用
local line_pitch = 405   -- 行数30用

-- メタデータから設定を読み取る
function Meta(meta)
  if meta['page-settings'] then
    local settings = meta['page-settings']

    if settings.chars then
      chars_per_line = tonumber(pandoc.utils.stringify(settings.chars))
    end

    if settings.lines then
      lines_per_page = tonumber(pandoc.utils.stringify(settings.lines))
    end

    -- 文字数・行数に応じてcharSpace/linePitchを計算
    -- 標準的な計算式（A4縦、余白30mm想定）
    -- charSpace: (ページ幅 - 左右余白) / 文字数 を twips で
    -- linePitch: (ページ高 - 上下余白) / 行数 を twips で

    -- 既知の値から逆算（文字数40=2242, 行数30=405）
    -- 近似計算
    char_space = math.floor(89680 / chars_per_line)
    line_pitch = math.floor(12150 / lines_per_page)
  end

  return meta
end

-- RawBlock内のセクション設定を書き換える
function RawBlock(el)
  if FORMAT == 'docx' and el.format == 'openxml' then
    -- セクション区切りにdocGrid設定を追加
    if el.text:match('<w:sectPr>') then
      -- 既存のdocGrid設定を削除
      local modified = el.text:gsub('<w:docGrid[^/]*/>', '')
      -- docGrid設定を追加（sectPrの閉じタグの直前）
      local doc_grid = string.format(
        '<w:docGrid w:type="linesAndChars" w:linePitch="%d" w:charSpace="%d"/>',
        line_pitch, char_space
      )
      modified = modified:gsub('</w:sectPr>', doc_grid .. '</w:sectPr>')
      return pandoc.RawBlock('openxml', modified)
    end
  end
  return el
end

-- 文書全体の処理
function Pandoc(doc)
  if FORMAT == 'docx' then
    -- 文書の最後のセクション設定にdocGrid設定とフッター参照を追加
    -- rId7=footer1(偶数ページ), rId8=footer2(奇数ページ/default)
    -- pgNumType w:start="1" でページ番号を1から開始
    local page_settings = string.format([[
<w:sectPr>
  <w:footerReference w:type="even" r:id="rId7"/>
  <w:footerReference w:type="default" r:id="rId8"/>
  <w:pgNumType w:start="1"/>
  <w:pgSz w:w="11906" w:h="16838"/>
  <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="720" w:footer="720" w:gutter="0"/>
  <w:cols w:space="720"/>
  <w:docGrid w:type="linesAndChars" w:linePitch="%d" w:charSpace="%d"/>
</w:sectPr>
]], line_pitch, char_space)
    table.insert(doc.blocks, pandoc.RawBlock('openxml', page_settings))
  end
  return doc
end
