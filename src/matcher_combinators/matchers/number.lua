local base = require('matcher_combinators.matchers.base')

local number = {}

function number.equals(expected)
  return base.compare(expected, function(a, b) return a == b end)
end

function number.different(expected)
  return base.compare(expected, function(a, b) return a ~= b end)
end

function number.bigger_than(expected)
  return base.compare(expected, function(a, b) return a > b end)
end

return number
