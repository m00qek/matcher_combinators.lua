local base = require("matcher_combinators.matchers.base")

local utils = require("matcher_combinators.utils")

local resolver = {}

function resolver.matcher(object, matchers)
   if utils.is_array(object) then
      return matchers.array(resolver.array(object, matchers))
   end

   if utils.is_table(object) then
      return matchers.table(resolver.table(object, matchers))
   end

   if utils.is_matcher(object) then
      return base.resolve(object, matchers)
   end

   local matcher = matchers[type(object)]
   if matcher then
      return matcher(object)
   end

   return base.equals('general_equals', object)
end

function resolver.table(expected, matchers)
   local resolved = { }
   for key, value in pairs(expected) do
      resolved[key] = resolver.matcher(value, matchers)
   end
   return resolved
end

function resolver.array(expected, matchers)
   local resolved = { }
   for index = 1, #expected do
      resolved[index] = resolver.matcher(expected[index], matchers)
   end
   return resolved
end

return resolver
