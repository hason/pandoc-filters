local container = {}
local filters = {}

function filters.import(module)
  for _, v in ipairs(require(module)) do
    table.insert(container, v)
  end
end

function filters.insert(filter)
  table.insert(container, filter)
end

function filters.all()
  return container
end

return filters
