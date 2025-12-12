-- TOC injection filter with toc-depth support
local toc_depth_start = 1
local toc_depth_end = 3

function Meta(meta)
  -- Read toc-depth from YAML metadata
  if meta["toc-depth"] then
    toc_depth_end = tonumber(pandoc.utils.stringify(meta["toc-depth"]))
  end
  return meta
end

function Para(elem)
  local text = pandoc.utils.stringify(elem)
  if text == "[TOC]" then
    -- Insert a TOC field using outline levels
    -- Pandocが生成する見出しスタイルには自動的にアウトラインレベルが設定される
    local toc_field = string.format(
      '<w:p><w:pPr><w:pStyle w:val="af0"/></w:pPr><w:r><w:t>目次</w:t></w:r></w:p>' ..
      '<w:p><w:fldSimple w:instr="TOC \\o &quot;%d-%d&quot; \\h \\z \\u" w:dirty="true">' ..
      '<w:r><w:rPr><w:noProof/></w:rPr><w:t>Right-click and select Update Field</w:t></w:r></w:fldSimple></w:p>',
      toc_depth_start, toc_depth_end
    )
    return pandoc.RawBlock('openxml', toc_field)
  end
end

return {{Meta = Meta}, {Para = Para}}
