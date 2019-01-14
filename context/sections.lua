-- Pandoc filter to process bibliography by ConTeXt

local pwd = debug.getinfo(1).source:match("^@?(.*[/\\])")
package.path = package.path .. ';' .. pwd .. '../?.lua'

local pandoc = require('pandoc')
local header_stack = {}

local function escape(s)
  return s:gsub("([#$%&\\{}[]|])", "\\%1")
end

local function header_name(header)
  local level = header.level
  local unnumbered = header.classes:includes('unnumbered')

  if level == -1 then
    return 'part'
  elseif level == 0 then
    if unnumbered then return 'title' else return 'chapter' end
  elseif level >= 1 then
    if unnumbered then name = 'subject' else name = 'section' end
    return string.rep('sub', level - 1) .. name
  end
end

local function stop_headers(level)
  local code = ''

  while #header_stack > 0 do
    local header = table.remove(header_stack)
    if nil == level or header.level >= level then
      code = code .. '\\stop' .. header_name(header) .. "\n"
    else
      table.insert(header_stack, header)
      break
    end
  end

  return code
end

function Header(header)
  local name = header_name(header)
  local before = stop_headers(header.level)
  local after = '\n'
  local variables = {}
  local user_variables = {}

  table.insert(header_stack, header)

  table.insert(variables, 'title={' .. escape(pandoc.utils.stringify(header.content)) .. '}')
  if header.attr.identifier then
    table.insert(variables, 'reference={' .. escape(header.attr.identifier) .. '}')
  end

  for k, v in pairs(header.attr.attributes) do
    table.insert(user_variables, k .. '={' .. escape(v) .. '}')
  end

  if #user_variables > 0 then
    after = '[' .. table.concat(user_variables, ', ') .. ']\n'
  end

  return pandoc.RawBlock(FORMAT, before .. "\\start" .. name .. '[' .. table.concat(variables, ', ') .. ']' .. after)
end

function Pandoc(doc)
  local text = stop_headers(nil)

  if #text then
    table.insert(doc.blocks, pandoc.RawBlock(FORMAT, text))
  end

  return doc
end

return {
  {Header = Header},
  {Pandoc = Pandoc}
}
