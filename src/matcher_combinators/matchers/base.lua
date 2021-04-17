local value = require("matcher_combinators.matchers.value")

local base = {}

function base.compare(expected, predicate)
   return function(actual)
      if predicate(expected, actual) then
         return actual
      end

      return value.mismatch(expected, actual)
   end
end

return base
