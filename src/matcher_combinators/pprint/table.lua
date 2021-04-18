local indent = require('matcher_combinators.pprint.indent')
local opts = require('matcher_combinators.pprint.options')

local tbl = {}

function tbl.pprint_key(key, printer)
   printer = printer or tostring

   if type(key) == 'string' then
      if key:match("[A-Za-z_][A-za-z0-9_]*") then
         return key
      end
      return '["' .. key .. '"]'
   end

   return '[' .. printer(key) .. ']'
end

local function concat(values, options, inner_options)
   local between = ',' .. inner_options.separator .. indent.text(inner_options.indentation)
   return '{' .. options.separator
      .. indent.text(inner_options.indentation) .. table.concat(values, between) .. options.separator
      .. indent.text(options.indentation) .. '}'
end

function tbl.pprint(object, options, join_lines, fn)
   local inner_options = opts.merge(options, {
      indentation = indent.next(options.indentation),
   })

   local values = {}

   for key, value in pairs(object) do
      local v1, v2 = fn(key, value, inner_options)
      if v1 then
         local text = v1
         if v2 then
            text = text .. ' = ' .. v2
         end
         table.insert(values, text)
      end
   end

   if join_lines then
      local none = opts.merge(options, {
         indentation = indent.none(),
         separator = ' ',
      })

      local printed = concat(values, none, none)
      if #printed < 80 then
         return printed
      end
   end

   return concat(values, options, inner_options)
end

return tbl
