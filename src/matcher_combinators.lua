local array = require("matcher_combinators.matchers.array")
local boolean = require("matcher_combinators.matchers.boolean")
local number = require("matcher_combinators.matchers.number")
local string = require("matcher_combinators.matchers.string")
local table = require("matcher_combinators.matchers.table")
local value = require("matcher_combinators.matchers.value")

local utils = require("matcher_combinators.utils")

local matcher_combinators = {}

local DEFAULT_MATCHERS = {
   boolean = boolean.equals,
   string  = string.equals,
   number  = number.equals,
   table   = table.contains,
   array   = array.equals,
}

local function resolve(object, matchers)
   if utils.is_array(object) then
      local expected = { }
      for index = 1, #object do
         expected[index] = resolve(object[index], matchers)
      end
      return matchers.array(expected)
   end

   if utils.is_table(object) then
      local expected = { }
      for k, v in pairs(object) do
         expected[k] = resolve(v, matchers)
      end
      return matchers.table(expected)
   end

   if utils.is_matcher(object) then
      return object
   end

   local matcher = matchers[type(object)]
   return matcher(object)
end

function matcher_combinators.matcher(expected, default_matchers)
   return resolve(expected, default_matchers or DEFAULT_MATCHERS)
end

function matcher_combinators.match(expected, actual, default_matchers)
   local matcher = matcher_combinators.matcher(expected, default_matchers)

   local result = matcher(actual)
   local matched = value.is_match(result)

   return matched, matched or result
end

return matcher_combinators
