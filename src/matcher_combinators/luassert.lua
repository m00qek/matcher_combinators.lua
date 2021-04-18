local matcher_combinators = require('matcher_combinators')
local pprint = require('matcher_combinators.pprint')
local value = require('matcher_combinators.matchers.value')

local assert = require("luassert")
local say = require("say")

local function match(_, arguments)
   local matched, result = matcher_combinators.match(arguments[1], arguments[2])

   if not matched then
      arguments[1] = result
   end

   return matched
end

assert:register(
   "assertion",
   "combinators_match",
   match,
   "assertion.combinators.match.positive",
   "assertion.combinators.match.negative")

assert:add_formatter(function(object)
   if not value.is_match(object) then
      return pprint.diff(object)
   end
end)

say:set("assertion.combinators.match.positive", "Values didn't match!\n%s")
say:set("assertion.combinators.match.negative", "Values matched!\n%s")
