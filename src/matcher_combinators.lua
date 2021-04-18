local array = require("matcher_combinators.matchers.array")
local boolean = require("matcher_combinators.matchers.boolean")
local number = require("matcher_combinators.matchers.number")
local string = require("matcher_combinators.matchers.string")
local table = require("matcher_combinators.matchers.table")
local value = require("matcher_combinators.matchers.value")

local resolver = require("matcher_combinators.resolver")

local matcher_combinators = {}

local DEFAULT_MATCHERS = {
   boolean = boolean.equals,
   string  = string.equals,
   number  = number.equals,
   table   = table.contains,
   array   = array.equals,
}

function matcher_combinators.matcher(expected, default_matchers)
   return resolver.resolve(expected, default_matchers or DEFAULT_MATCHERS)
end

function matcher_combinators.match(expected, actual, default_matchers)
   local matcher = matcher_combinators.matcher(expected, default_matchers)

   local result = matcher(actual)
   local matched = value.is_match(result)

   return matched, matched or result
end

return matcher_combinators

