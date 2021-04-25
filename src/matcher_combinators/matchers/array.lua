local base = require("matcher_combinators.matchers.base")
local value = require("matcher_combinators.matchers.value")
local resolver = require("matcher_combinators.resolver")

local utils = require("matcher_combinators.utils")

local function element(matcher, actual)
   if matcher == nil then
      return value.unexpected(actual)
   end

   if actual == nil then
      return value.missing(matcher)
   end

   return matcher(actual)
end

local function empty(actual)
   if not utils.is_array(actual) then
      return value.mismatch({ }, actual)
   end

   if #actual == 0 then
      return actual
   end

   local mismatched = {}
   for _, item in ipairs(actual) do
      table.insert(mismatched, value.unexpected(item))
   end

   return value.with_failures(mismatched)
end

local function contains(actual, expected)
   if not utils.is_array(actual) then
      return value.mismatch(expected, actual)
   end

   local newarray = {}
   for _, matcher in ipairs(expected) do
      local matched = false

      for _, item in ipairs(actual) do
         if value.is_match(matcher(item)) then
            matched = true
            break
         end
      end

      if not matched then
         table.insert(newarray, value.missing(matcher))
      end
   end

   if #newarray > 0 then
      return value.with_failures(newarray)
   end

   return actual
end

local function equals(actual, expected)
   if not utils.is_array(actual) then
      return value.mismatch(expected, actual)
   end

   local newarray = {}
   local matched = true

   local index = 1
   while index <= #expected do
      local object = element(expected[index], actual[index])

      newarray[index] = object
      if value.is_match(object) then
         newarray[index] = value.keep(object)
      end

      matched = matched and value.is_match(object)
      index = index + 1
   end

   if #expected < #actual then
      matched = false

      while index <= #actual do
         newarray[index] = value.unexpected(actual[index])
         index = index + 1
      end
   end

   if not matched then
      return value.with_failures(newarray)
   end

   return actual
end

local function starts_with(actual, expected)
   local newarray = {}
   local matched = true

   if not utils.is_array(actual) then
      return value.mismatch(expected, actual)
   end

   for index = 1, #expected do
      local object = element(expected[index], actual[index])

      newarray[index] = object
      if value.is_match(object) then
         newarray[index] = value.keep(object)
      end

      matched = matched and value.is_match(object)
   end

   if not matched then
      return value.with_failures(newarray)
   end

   return actual
end

local array = {}

function array.empty()
   return base.matcher(empty, { name = "array.empty" })
end

function array.contains(expected)
   return base.matcher(contains, {
      expected = expected,
      resolver = resolver.array,
      name     = "array.contains",
   })
end

function array.equals(expected)
   return base.matcher(equals, {
      expected = expected,
      resolver = resolver.array,
      name     = "array.equals",
   })
end

function array.starts_with(expected)
   return base.matcher(starts_with, {
      expected = expected,
      resolver = resolver.array,
      name     = "array.starts_with",
   })
end

return array
