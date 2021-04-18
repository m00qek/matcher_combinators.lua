local colors = {}

local function isWindows()
  return type(package) == 'table' and type(package.config) == 'string' and package.config:sub(1,1) == '\\'
end

local supported = not isWindows()
if isWindows() then
   supported = os.getenv("ANSICON")
end

function colors.red(text)
   if supported then
      return "\x1b[1;31m" .. text .. "\x1b[0m"
   end
   return text
end

function colors.yellow(text)
   if supported then
      return "\x1b[1;33m" .. text .. "\x1b[0m"
   end
   return text
end

return colors
