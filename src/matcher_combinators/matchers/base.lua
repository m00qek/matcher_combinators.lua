local value = require("matcher_combinators.matchers.value")

local base = {}

local function with_resolver(matchfn, resolver, meta)
   return function(resolvefn)
      local expected = resolver(resolvefn)

      return base.matcher(function(actual)
         return matchfn(actual, expected)
      end, { name = meta.name, expected = meta.expected })
   end
end

function base.matcher(fn, meta)
   local matcher = {
      expected = meta.expected,
   }

   local resolver = function(_) return matcher end
   if meta.resolver then
      resolver = with_resolver(fn, meta.resolver, meta)
   end

   setmetatable(matcher, {
      kind = "matcher_combinators/matcher",
      resolver = resolver,
      __call = function(self, actual) return fn(actual, self.expected) end,
      __name = "matcher(" .. (meta.name or tostring(fn)) .. ")",
   })

   return matcher
end

function base.resolve(matcher, resolverfn)
   return getmetatable(matcher).resolver(resolverfn)
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
