local indent = require('matcher_combinators.printers.indent')

local opts = {}

function opts.merge(options, values)
   return {
      with_matches = values.with_matches or options.with_matches,
      indentation = values.indentation or options.indentation,
      separator = values.separator or options.separator,
   }
end

function opts.default()
   return {
      with_matches = false,
      indentation = indent.default(),
      separator = '\n',
   }
end

return opts
