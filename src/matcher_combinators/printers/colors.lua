local colors = {}

function colors.red(text)
   return "\x1b[1;31m" .. text .. "\x1b[0m"
end

function colors.yellow(text)
   return "\x1b[1;33m" .. text .. "\x1b[0m"
end

return colors
