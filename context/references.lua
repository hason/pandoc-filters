local pwd = debug.getinfo(1).source:match("^@?(.*[/\\])")
package.path = package.path .. ";" .. pwd .. "../?.lua"

local pandoc = require("pandoc")

local function Span(el)
  local id = el.attr.identifier
  if id then
    return {
      pandoc.RawInline("context", "\\textreference[" .. id .. "]{"),
      pandoc.Str(el.content),
      pandoc.RawInline("context", "}"),
      el
    }
  end
end

if FORMAT == "context" then
  return {
    {Span = Span}
  }
else
  return {}
end
