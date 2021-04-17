local base = require("matcher_combinators.matchers.base")
local value = require("matcher_combinators.matchers.value")

local matchers = {}

function matchers.anything()
   return base.matcher(function(actual)
      return actual
   end, { name = "anything" })
end

function matchers.predicate(fn, message)
   return base.matcher(function(actual)
      if fn(actual) then
         return actual
      end

      return value.failure({error = message, actual = actual })
   end, { name = "predicate" })
end

return matchers
