local colors = {}

local supported = package.config:sub(1,1) ~= '\\' or os.getenv("ANSICON")

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
