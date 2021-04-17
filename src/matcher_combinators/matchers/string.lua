local base = require('matcher_combinators.matchers.base')

local string = {}

function string.equals(expected)
  return base.compare(expected, function(a, b) return a == b end)
end

return string
