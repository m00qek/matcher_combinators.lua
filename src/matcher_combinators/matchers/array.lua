local base = require("matcher_combinators.matchers.base")
local value = require("matcher_combinators.matchers.value")

local utils = require("matcher_combinators.utils")

local function resolve(expected)
   return function(resolverfn)
      local resolved = { }
      for index = 1, #expected do
         resolved[index] = resolverfn(expected[index])
      end
      return resolved
   end
end

local function element(matcher, actual)
   if not matcher then
      return value.unexpected(actual)
   end

   if not actual then
      return value.missing(matcher)
   end

   return matcher(actual)
end

local function equals(actual, expected)
   local newarray = {}
   local matched = true

   if not utils.is_array(actual) then
      return value.mismatch(expected, actual)
   end

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

function array.equals(expected)
   return base.matcher(equals, {
      expected = expected,
      resolver = resolve(expected),
      name     = "array.equals",
   })
end

function array.starts_with(expected)
   return base.matcher(starts_with, {
      expected = expected,
      resolver = resolve(expected),
      name     = "array.starts_with",
   })
end

return array
