-- Pandoc filter to process bibliography by ConTeXt

local pwd = debug.getinfo(1).source:match("^@?(.*[/\\])")
package.path = package.path .. ';' .. pwd .. '../?.lua'

local pandoc = require('pandoc')
require('file')

local name = 'default'

local function parse_references(data)
  local s = ''
  local reftype, buffer
  for id, entry in pairs(data) do
    reftype = 'book'
    buffer = ',\n'
    for k, v in pairs(entry) do
      if type(v) == 'table' then
        v = pandoc.utils.stringify(v)
      end

      if k == 'id' then id = v end
      if k == 'type' then reftype = v end
      if k ~= 'id' and k ~= 'type' then
        buffer = buffer .. '  ' .. k .. ' = {' .. v .. '},\n'
      end
    end
    s = s .. '@' .. reftype ..  '{' .. id .. buffer ..'}\n'
  end

  return s
end

function Pandoc(doc)
  local bibliography = ''
  local suppress = false

  for k, v in pairs(doc.meta) do
    if k == 'bibliography' then
      for _, filename in pairs(v) do
        filename = resolve_file(pandoc.utils.stringify(filename))
        bibliography = bibliography .. read_file(filename)
        name = fileinfo(filename).basename
      end
    elseif k == 'suppress-bibliography' then
      suppress = v
    elseif k == 'reference-section-title' then
    elseif k == 'references' and (v.t == 'MetaMap' or v.t == 'MetaList') then
      bibliography = bibliography .. parse_references(v)
    -- elseif k == 'references_name' then
    --   name = pandoc.utils.stringify(v)
    elseif k == 'nocite' then -- \usecitation
      -- TODO http://pandoc.org/MANUAL.html#citations
    end
  end

  if #bibliography > 0 then
    local buffer = pandoc.utils.sha1(bibliography)
    table.insert(doc.blocks, 1, pandoc.RawBlock(FORMAT, '\\startbuffer[' .. buffer .. ']\n' .. bibliography .. '\\stopbuffer'))
    table.insert(doc.blocks, 2, pandoc.RawBlock(FORMAT, '\\definebtxdataset[' .. name .. ']\n\\usebtxdataset[' .. name .. '][' .. buffer .. '.buffer]'))
    table.insert(doc.blocks, 3, pandoc.RawBlock(FORMAT, '\\definebtxrendering[' .. name .. '][dataset=' .. name .. ', group=' .. name .. ']'))
  end

  if suppress then
    return doc
  end

  publications = pandoc.RawBlock(FORMAT, '\\placelistofpublications[' .. name .. ']\n')

  local div_metadata = getmetatable(pandoc.Div({}))
  for _, el in pairs(doc.blocks) do
    if getmetatable(el) == div_metadata and el.attr.identifier == 'refs' then
      table.insert(el.content, publications)
      return doc
    end
  end

  table.insert(doc.blocks, publications)
  return doc
end

function Cite(el)
  -- add prefix only for the first item
  local cite = el.citations[1]
  if cite.suffix[1] ~= nil and cite.suffix[1].text ~= nil and cite.suffix[1].text:match('^::[^ ]+$') then
    cite.id = cite.id .. cite.suffix[1].text
    table.remove(cite.suffix, 1)
  else
    cite.id = name .. '::' .. cite.id
  end

  return el
end

return {
  {Pandoc = Pandoc},
  {Cite = Cite},
}
