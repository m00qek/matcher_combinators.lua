local base = require('matcher_combinators.matchers.base')
local value = require("matcher_combinators.matchers.value")

local matchers = {}

function matchers.anything()
   return function(actual)
      return actual
   end
end

function matchers.nothing()
   return base.compare(nil, function(_, actual) return actual == nil end)
end

function matchers.predicate(fn, message)
   return function(actual)
      if fn(actual) then
         return actual
      end

      return value.failure({error = message, actual = actual })
   end
end



return matchers

