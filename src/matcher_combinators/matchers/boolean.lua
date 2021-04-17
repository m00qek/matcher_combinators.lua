local base = require('matcher_combinators.matchers.base')
local value = require("matcher_combinators.matchers.value")

local boolean = {}

function boolean.equals(expected)
   return base.equals("boolean.equals", expected)
end

function boolean.truthy()
   return base.matcher(function(actual)
      if actual then
         return actual
      end
      return value.failure({ actual = actual })
   end, { name = 'boolean.truthy' })
end

function boolean.falsey()
   return base.matcher(function(actual)
      if not actual then
         return actual
      end
      return value.failure({ actual = actual })
   end, { name = 'boolean.falsey' })
end

return boolean
