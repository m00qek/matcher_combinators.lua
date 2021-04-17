local base = require('matcher_combinators.matchers.base')

local table = {}

local function entry(raw, matcher, actual)
   if not matcher then
      return base.unexpected(actual)
   end

   if not actual then
      return base.missing(raw or matcher)
   end

   return matcher(actual)
end

function table.contains(expected, raw)
   return function(actual)
      local newtable = {}

      if type(actual) ~= 'table' then
         return base.mismatch(raw or expected, actual)
      end

      local matched = true
      for key, matcher in pairs(expected) do
         newtable[key] = entry(raw[key], matcher, actual[key])
         matched = matched and base.matched(newtable[key])
      end

      if not matched then
         return base.mismatched(newtable)
      end

      return actual
   end
end

return table
