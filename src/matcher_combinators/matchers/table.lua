local value = require("matcher_combinators.matchers.value")

local table = {}

local function entry(raw, matcher, actual)
   if not matcher then
      return value.unexpected(actual)
   end

   if not actual then
      return value.missing(raw or matcher)
   end

   return matcher(actual)
end

function table.contains(expected, raw)
   return function(actual)
      local newtable = {}

      if type(actual) ~= 'table' then
         return value.mismatch(raw or expected, actual)
      end

      local matched = true
      for key, matcher in pairs(expected) do
         newtable[key] = entry(raw[key], matcher, actual[key])
         matched = matched and value.is_match(newtable[key])
      end

      if not matched then
         return value.with_failures(newtable)
      end

      return actual
   end
end

return table
