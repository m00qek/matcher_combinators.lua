local v = {}

local KEYS = {
   mismatched = 'matcher_combinators/mismatched',
   failure    = 'matcher_combinators/failure',
   keep       = 'matcher_combinators/keep',
}

function v.failure(value)
   return { [KEYS.failure] = value }
end

function v.mismatched(value)
   return { [KEYS.mismatched] = value }
end

function v.keep(value)
   return { [KEYS.keep] = value }
end

function v.unexpected(actual)
   return v.failure({ unexpected = actual })
end

function v.missing(expected)
   return v.failure({ missing = expected })
end

function v.mismatch(expected, actual)
   return v.failure({ expected = expected, actual = actual })
end

-- getter
function v.get(value)
   if type(value) == 'table' then
      for _, key in pairs(KEYS) do
         if value[key] then
            return value[key]
         end
      end
   end
   return value
end

-- predicates
function v.has_failure(value)
   return type(value) == 'table' and value[KEYS.mismatched]
end

function v.is_failure(value)
   return type(value) == 'table' and value[KEYS.failure]
end

function v.should_keep(value)
   return type(value) == 'table' and value[KEYS.keep]
end

function v.is_match(value)
   return not (v.has_failure(value) or v.is_failure(value))
end

return v
