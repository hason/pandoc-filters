local pandoc = require('pandoc')

local function RawBlock(block)
  if block.format == 'latex' or block.format == 'tex' then
    block.format = 'context'
  end

  return block
end

return {
  {RawBlock = RawBlock}
}
