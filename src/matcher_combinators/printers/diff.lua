local value = require('matcher_combinators.matchers.value')
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
      return colors.red(table.pprint(failure, failure_options, true, function(k, v, _)
         return
            table.pprint_key(k:upper()),
            pprint_value(v, failure_options)
      end))
   end

   return table.pprint(failure, options, false, function(k, v, _)
      if k == 'expected' then
         return
            table.pprint_key(k:upper()),
            colors.yellow(pprint_value(v, failure_options))
      end

      return
         table.pprint_key(k:upper()),
         colors.red(pprint_value(v, failure_options))
   end)
end

pprint_value = function (object, options)
   if utils.is_array(object) then
      return table.pprint(object, options, true, function(_, v, inner_options)
         return pprint(v, inner_options)
      end)
   end

   if utils.is_table(object) then
      return table.pprint(object, options, false, function(k, v, inner_options)
         local printed = pprint(v, inner_options)
         if printed then
            return table.pprint_key(k), printed
         end
      end)
   end

   if type(object) == 'string' then
      return '"' .. object .. '"'
   end

   return tostring(object)
end

pprint = function(object, options)
   if value.is_failure(object) then
      return pprint_failure(value.get(object), options)
   end

   if value.has_failure(object) or value.should_keep(object) then
      return pprint_value(value.get(object), options)
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
