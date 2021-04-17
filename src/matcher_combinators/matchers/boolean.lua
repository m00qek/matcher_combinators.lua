local base = require('matcher_combinators.matchers.base')

local boolean = {}

function boolean.equals(expected)
   return base.compare(expected, function(a, b) return a == b end)
end

function boolean.truthy()
   return function(actual)
      if actual then
         return actual
      end

      return base.failure({ actual = actual })
   end
end

function boolean.falsey()
   return function(actual)
      if not actual then
         return actual
      end

      return base.failure({ actual = actual })
   end
end

return boolean
