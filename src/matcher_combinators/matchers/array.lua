local base = require('matcher_combinators.matchers.base')
local utils = require('matcher_combinators.utils')

local array = {}

local function element(raw, matcher, actual)
   if not matcher then
      return base.unexpected(actual)
   end

   if not actual then
      return base.missing(raw or matcher)
   end

   return matcher(actual)
end

function array.starts_with(expected, raw)
   return function(actual)
      local newarray = {}
      local matched = true

      if not utils.is_array(actual) then
         return base.mismatch(raw or expected, actual)
      end

      for index = 1, #expected do
         local value = element(raw[index], expected[index], actual[index])

         newarray[index] = value
         if base.matched(value) then
            newarray[index] = base.keep(value)
         end

         matched = matched and base.matched(value)
      end

      if not matched then
         return base.mismatched(newarray)
      end

      return actual
   end
end

return array
