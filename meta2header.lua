local pandoc = require 'pandoc'

local vars = {}
local copyed = false

function get_vars(meta)
  for k, v in pairs(meta) do
    if type(v) ~= 'table' or v.t ~= 'MetaMap' then
      vars[k] = pandoc.utils.stringify(v)
    end
  end
end

function add_vars(el)
  if copyed then
    return el
  end

  for k, v in pairs(el.attr.attributes) do
    vars[k] = v
  end

  el.attr = pandoc.Attr(el.attr.identifier, el.attr.classes, vars)
  copyed = true

  return el
end

return {
  {Meta = get_vars},
  {Header = add_vars}
}
