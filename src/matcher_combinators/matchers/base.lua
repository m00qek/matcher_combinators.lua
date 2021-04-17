local value = require("matcher_combinators.matchers.value")

local base = {}

function base.matcher(fn, meta)
   local new_matcher = {
      expected = meta.expected
   }

   setmetatable(new_matcher, {
      __call = function(_, actual) return fn(actual) end,
      __name = "<matcher: " .. (meta.name or tostring(fn)) .. ">",
   })

   return new_matcher
end

function base.expected(matcher)
   if type(matcher) == 'function' then
      return tostring(matcher)
   end

   return matcher.expected or tostring(matcher)
end

function base.compare(expected, predicate)
   return base.matcher(function(actual)
      if predicate(expected, actual) then
         return actual
      end

      return value.mismatch(expected, actual)
   end, { expected = expected })
end

return base
