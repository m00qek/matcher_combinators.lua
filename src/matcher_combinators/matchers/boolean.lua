local base = require('matcher_combinators.matchers.base')
local value = require("matcher_combinators.matchers.value")

local boolean = {}

function boolean.equals(expected)
   return base.compare(expected, function(a, b) return a == b end)
end

function boolean.truthy()
   return function(actual)
      if actual then
         return actual
      end

      return value.failure({ actual = actual })
   end
end

function boolean.falsey()
   return function(actual)
      if not actual then
         return actual
      end

      return value.failure({ actual = actual })
   end
end

return boolean
