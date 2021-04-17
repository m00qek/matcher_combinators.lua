local value = require("matcher_combinators.matchers.value")

local utils = require('matcher_combinators.utils')

local array = {}

local function element(raw, matcher, actual)
   if not matcher then
      return value.unexpected(actual)
   end

   if not actual then
      return value.missing(raw or matcher)
   end

   return matcher(actual)
end

function array.starts_with(expected, raw)
   return function(actual)
      local newarray = {}
      local matched = true

      if not utils.is_array(actual) then
         return value.mismatch(raw or expected, actual)
      end

      for index = 1, #expected do
         local object = element(raw[index], expected[index], actual[index])

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
end

return array
