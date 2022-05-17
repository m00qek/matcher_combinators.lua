local base = require('matcher_combinators.matchers.base')
local value = require('matcher_combinators.matchers.value')

local str = {}

function str.equals(expected)
   return base.equals("string.equals", expected)
end

function str.regex(expected)
   return base.matcher(function(actual)
      if string.match(actual, expected) then
         return actual
      end
      return value.mismatch(expected, actual)
   end, { name = 'string.regex' })
end

return str
