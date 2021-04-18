local utils = {}

function utils.is_matcher(value)
   if type(value) ~= 'table' then
      return false
   end

   local meta = getmetatable(value) or {}
   return meta.kind == 'matcher_combinators/matcher'
end

function utils.is_array(value)
   if type(value) ~= 'table' or utils.is_matcher(value) then
      return false
   end

   local index = 1
   for key, _ in pairs(value) do
      if key ~= index then
         return false
      end

      index = index + 1
   end

   return true
end

local function is_empty(tbl)
   return next(tbl) == nil
end

function utils.is_table(value)
   if type(value) ~= 'table' or utils.is_matcher(value) then
      return false
   end

   return is_empty(value) or not utils.is_array(value)
end

return utils
