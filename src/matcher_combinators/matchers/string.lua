local base = require('matcher_combinators.matchers.base')

local string = {}

function string.equals(expected)
   return base.equals("string.equals", expected)
end

return string
