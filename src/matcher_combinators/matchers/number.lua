local base = require("matcher_combinators.matchers.base")

local number = {}

function number.equals(expected)
   return base.equals("number.equals", expected)
end

return number
