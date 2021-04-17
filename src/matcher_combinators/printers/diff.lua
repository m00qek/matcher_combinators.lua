local base = require('matcher_combinators.matchers.base')
local colors = require('matcher_combinators.printers.colors')
local indent = require('matcher_combinators.printers.indent')
local table = require('matcher_combinators.printers.table')
local opts = require('matcher_combinators.printers.options')
local utils = require('matcher_combinators.utils')

local diff = {}

local pprint, pprint_failure, pprint_value

pprint_failure = function(failure, options)
   local failure_options = opts.merge(options, {
      with_matches = true,
      indentation  = indent.none(),
      separator    = ' ',
   })

   if failure.missing or failure.unexpected then
      return colors.red(table.pprint(failure, failure_options, true, function(key, value, _)
         return
            table.pprint_key(key:upper()),
            pprint_value(value, failure_options)
      end))
   end

   return table.pprint(failure, options, false, function(key, value, _)
      if key == 'expected' then
         return
            table.pprint_key(key:upper()),
            colors.yellow(pprint_value(value, failure_options))
      end

      return
         table.pprint_key(key:upper()),
         colors.red(pprint_value(value, failure_options))
   end)
end

pprint_value = function (object, options)
   if utils.is_array(object) then
      return table.pprint(object, options, true, function(_, value, inner_options)
         return pprint(value, inner_options)
      end)
   end

   if utils.is_table(object) then
      return table.pprint(object, options, false, function(key, value, inner_options)
         local printed = pprint(value, inner_options)
         if printed then
            return table.pprint_key(key), printed
         end
      end)
   end

   if type(object) == 'string' then
      return '"' .. object .. '"'
   end

   return tostring(object)
end

pprint = function(object, options)
   if base.is_failure(object) then
      return pprint_failure(base.value(object), options)
   end

   if base.has_failure(object) or base.should_keep(object) then
      return pprint_value(base.value(object), options)
   end

   if options.with_matches then
      return pprint_value(object, options)
   end
end

function diff.pprint(object, options)
   return pprint(object, options or {
      with_matches = false,
      indentation = indent.default(),
      separator = '\n',
   })
end

return diff
