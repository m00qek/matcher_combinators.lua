local base = require("matcher_combinators.matchers.base")
local value = require("matcher_combinators.matchers.value")

local utils = require("matcher_combinators.utils")

local function resolve(expected)
   return function(resolverfn)
      local resolved = { }
      for k, v in pairs(expected) do
         resolved[k] = resolverfn(v)
      end
      return resolved
   end
end

local function entry(matcher, actual)
   if not matcher then
      return value.unexpected(actual)
   end

   if not actual then
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
      resolver = resolve(expected),
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
