local value = require("matcher_combinators.matchers.value")

local base = {}

function base.matcher(matchfn, meta)
   local matcher = {
      expected = meta.expected,
   }

   local resolver = function(_, _) return matcher end
   if meta.resolver then
      resolver = function(object, matchers)
         local expected = meta.resolver(object, matchers)

         return base.matcher(
            function(actual) return matchfn(actual, expected) end,
            { name = meta.name, expected = expected })
      end
   end

   setmetatable(matcher, {
      kind = "matcher_combinators/matcher",
      resolve = resolver,
      __call = function(self, actual) return matchfn(actual, self.expected) end,
      __name = "matcher(" .. (meta.name or tostring(matchfn)) .. ")",
   })

   return matcher
end

function base.resolve(matcher, default_matchers)
   return getmetatable(matcher).resolve(matcher.expected, default_matchers)
end

function base.equals(name, expected)
   return base.matcher(function(actual)
      if expected == actual then
         return actual
      end

      return value.mismatch(expected, actual)
   end, { name = name, expected = expected })
end

return base
