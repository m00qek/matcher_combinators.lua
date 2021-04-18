local base = require("matcher_combinators.matchers.base")
local utils = require("matcher_combinators.utils")

local resolver = {}

function resolver.resolve(object, matchers)
   if utils.is_array(object) then
      local expected = { }
      for index = 1, #object do
         expected[index] = resolver.resolve(object[index], matchers)
      end
      return matchers.array(expected)
   end

   if utils.is_table(object) then
      local expected = { }
      for k, v in pairs(object) do
         expected[k] = resolver.resolve(v, matchers)
      end
      return matchers.table(expected)
   end

   if utils.is_matcher(object) then
      return base.resolve(object, function(obj)
         return resolver.resolve(obj, matchers)
      end)
   end

   local matcher = matchers[type(object)]
   if matcher then
      return matcher(object)
   end

   return base.equals('general_equals', object)
end

return resolver
