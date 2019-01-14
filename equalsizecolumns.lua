local pandoc = require 'pandoc'

function Table(el)
  local widths = {}
  local width = 1/#el.widths

  for k, _ in pairs(el.widths) do
    widths[k] = width
  end

  return pandoc.Table(el.caption, el.aligns, widths, el.headers, el.rows)
end

return {
  {Table = Table},
}
