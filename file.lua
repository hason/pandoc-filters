function fileinfo(path)
  filename, basename, extension = path:match('(([^/]-).?([^.]+))$')

  return {
    path = string.sub(path, 0, -#filename - 1),
    filename = filename,
    basename = basename,
    extension = extension,
  }
end

function resolve_file(name)
  if PANDOC_STATE == nil or file_exists(name) then return name end

  for _, file in pairs(PANDOC_STATE.input_files) do
    path = fileinfo(file).path .. name
    if file_exists(path) then
      return path
    end
  end

  return name
end

function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then io.close(f) return true else return false end
end

function read_file(name)
  local content = ''
  local f = io.open(name, 'r')
  if f ~= nil then
      content = f:read('*all')
      io.close(f)
  end

  return content
end
