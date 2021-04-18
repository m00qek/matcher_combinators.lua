local indent = require('matcher_combinators.pprint.indent')
local printer = require("matcher_combinators.pprint.printer")

local pprint = { }

function pprint.full(value)
   return printer.pprint(value, {
      with_matches = true,
      indentation = indent.default(),
      separator = '\n',
   })
end

function pprint.diff(value)
   return printer.pprint(value, {
      with_matches = false,
      indentation = indent.default(),
      separator = '\n',
   })
end

return pprint
