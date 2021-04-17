local base = {}

local KEYS = {
   mismatched = 'matcher_combinators/mismatched',
   failure    = 'matcher_combinators/failure',
   keep       = 'matcher_combinators/keep',
}

function base.failure(value)
   return { [KEYS.failure] = value }
end

function base.mismatched(value)
   return { [KEYS.mismatched] = value }
end

function base.keep(value)
   return { [KEYS.keep] = value }
end


function base.value(value)
   if type(value) == 'table' then
      for _, key in pairs(KEYS) do
         if value[key] then
            return value[key]
         end
      end
   end
   return value
end


function base.has_failure(value)
   return type(value) == 'table' and value[KEYS.mismatched]
end

function base.is_failure(value)
   return type(value) == 'table' and value[KEYS.failure]
end

function base.should_keep(value)
   return type(value) == 'table' and value[KEYS.keep]
end

function base.matched(value)
   return not (base.has_failure(value) or base.is_failure(value))
end


function base.unexpected(actual)
   return base.failure({ unexpected = actual })
end

function base.missing(expected)
   return base.failure({ missing = expected })
end

function base.mismatch(expected, actual)
   return base.failure({ expected = expected, actual = actual })
end


function base.compare(expected, predicate)
   return function(actual)
      if predicate(expected, actual) then
         return actual
      end

      return base.mismatch(expected, actual)
   end
end

return base
