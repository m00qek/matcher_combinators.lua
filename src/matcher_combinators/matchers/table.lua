local base = require("matcher_combinators.matchers.base")
local value = require("matcher_combinators.matchers.value")

local utils = require("matcher_combinators.utils")

local table = {}

local function entry(matcher, actual)
   if not matcher then
      return value.unexpected(actual)
   end

   if not actual then
      return value.missing(matcher)
   end

   return matcher(actual)
end

function table.absent()
   return base.matcher(function(actual)
      if actual == nil then
         return actual
      end

      return value.unexpected(actual)
   end, { name = 'key.absent' })
end

function table.contains(expected)
   return base.matcher(function(actual)
      local newtable = { }

      if not utils.is_table(actual) then
         return value.mismatch(expected, actual)
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
   end, { name = 'table.contains', expected = expected })
end

return table
