local pwd = debug.getinfo(1).source:match("^@?(.*[/\\])")
package.path = package.path .. ';' .. pwd .. '../?.lua'

local pandoc = require('pandoc')

local function Span(el)
  local id = el.attr.identifier
  if id and 'context' == FORMAT then
    return {pandoc.RawInline(FORMAT, '\\textreference[' .. id .. ']{' .. pandoc.utils.stringify(el.content) .. '}'), el}
  end
end

if FORMAT == 'context' then
  return {
    {Span = Span}
  }
else
  return {}
end
