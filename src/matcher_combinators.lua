local base = require('matcher_combinators.matchers.base')
local boolean = require('matcher_combinators.matchers.boolean')
local string = require('matcher_combinators.matchers.string')
local number = require('matcher_combinators.matchers.number')
local table = require('matcher_combinators.matchers.table')
local array = require('matcher_combinators.matchers.array')
local utils = require('matcher_combinators.utils')

local matcher_combinators = {}

local DEFAULT_MATCHERS = {
   boolean = boolean.equals,
   string  = string.equals,
   number  = number.equals,
   table   = table.contains,
   array   = array.starts_with,
}

local function resolve(object, matchers)
   if utils.is_array(object) then
      local expected = {}
      for index = 1, #object do
         expected[index] = resolve(object[index], matchers)
      end
      return matchers.array(expected, object)
   end

   if utils.is_table(object) then
      local expected = {}
      for key, value in pairs(object) do
         expected[key] = resolve(value, matchers)
      end
      return matchers.table(expected, object)
   end

   return matchers[type(object)](object)
end

function matcher_combinators.matcher(expected, default_matchers)
   return resolve(expected, default_matchers or DEFAULT_MATCHERS)
end

function matcher_combinators.match(expected, actual, default_matchers)
   local matcher = matcher_combinators.matcher(expected, default_matchers)

   local result = matcher(actual)
   local matched = base.matched(result)

   return matched, matched or result
end

return matcher_combinators
