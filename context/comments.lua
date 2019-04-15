local pwd = debug.getinfo(1).source:match("^@?(.*[/\\])")
package.path = package.path .. ";" .. pwd .. "../?.lua"

local pandoc = require("pandoc")
local List = require('pandoc.List')

local function Span(el)
  if el.classes:includes("comment-start") then
    local author = el.attributes["author"]
    local elements = { pandoc.RawInline("context", "\\comment") }
    if nil ~= author then
      List.extend(
        elements,
        {
          pandoc.RawInline("context", "[author={"),
          pandoc.Str(author),
          pandoc.RawInline("context", "}]")
        }
      )
    end

    List.extend(
      elements,
      {
        pandoc.RawInline("context", "{"),
        el,
        pandoc.RawInline("context", "}")
      }
    )

    return elements
  end
end

if FORMAT == "context" then
  return {
    { Span = Span }
  }
else
  return {}
end
