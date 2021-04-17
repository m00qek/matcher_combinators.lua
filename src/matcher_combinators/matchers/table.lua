local base = require("matcher_combinators.matchers.base")
local value = require("matcher_combinators.matchers.value")

local utils = require("matcher_combinators.utils")

local table = {}

local function entry(matcher, actual)
   if not matcher then
      return value.unexpected(actual)
   end

   if not actual then
      return value.missing(base.expected(matcher))
   end

   return matcher(actual)
end

function table.contains(expected, raw)
   return base.matcher(function(actual)
      local newtable = {}

      if not utils.is_table(actual) then
         return value.mismatch(raw or expected, actual)
      end

      local matched = true
      for key, matcher in pairs(expected) do
         newtable[key] = entry(matcher, actual[key])
         matched = matched and value.is_match(newtable[key])
      end

      if not matched then
         return value.with_failures(newtable)
      end

      return actual
   end, { name = 'table.contains', expected = raw or expected })
end

return table
