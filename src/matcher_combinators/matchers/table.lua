local base = require("matcher_combinators.matchers.base")
local value = require("matcher_combinators.matchers.value")
local resolver = require("matcher_combinators.resolver")

local utils = require("matcher_combinators.utils")

local function entry(matcher, actual)
   if matcher == nil then
      return value.unexpected(actual)
   end

   if actual == nil then
      return value.missing(matcher)
   end

   return matcher(actual)
end

local function contains(actual, expected)
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
end

local tbl = {}

function tbl.contains(expected)
   return base.matcher(contains, {
      expected = expected,
      resolver = resolver.table,
      name     = "table.contains",
   })
end

function tbl.absent()
   return base.matcher(function(actual)
      if actual == nil then
         return actual
      end

      return value.unexpected(actual)
   end, { name = "key.absent" })
end

return tbl
