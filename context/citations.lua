-- Pandoc filter to process bibliography by ConTeXt

local pwd = debug.getinfo(1).source:gsub('^@', ''):match("^(.*[/\\])")
package.path = package.path .. ';' .. pwd .. '../?.lua'

local pandoc = require('pandoc')
local List = require('pandoc.List')

local function escape(s)
  return s:gsub("([#$%&\\{}[]|])", "\\%1")
end

local function add_braces(el)
  table.insert(el, 1, pandoc.RawInline(FORMAT, '{'))
  table.insert(el, pandoc.RawInline(FORMAT, '}, '))

  return el
end

local function extends(...)
  local arg={...}
  local list = {}
  for _,v in ipairs(arg) do
    List.extend(list, v)
  end

  return list
end

function Cite(el)
  local prefix = {}
  local suffix = {}
  local ids = {}

  for _,cite in ipairs(el.citations) do
    table.insert(ids, cite.id)
    List.extend(prefix, add_braces(cite.prefix))
    List.extend(suffix, add_braces(cite.suffix))
    --cite.hash
    --cite.note_num

    if cite.mode == 'AuthorInText' then
    elseif cite.mode == 'NormalCitation' then
    elseif cite.mode == 'SuppressAuthor' then
    end
  end

  return extends(
    {pandoc.RawInline(FORMAT, '\\cite[lefttext={')}, prefix, {pandoc.RawInline(FORMAT, '},righttext={')}, suffix,
    {pandoc.RawInline(FORMAT, '}][' .. table.concat(ids, ',') .. ']')}
  )
end

return {
  {Cite = Cite}
}
