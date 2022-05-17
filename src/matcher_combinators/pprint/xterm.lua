local supported = package.config:sub(1,1) ~= '\\' or os.getenv("ANSICON")

local function escape_sequence(ansi_code)
   return string.char(27) .. '[' .. tostring(ansi_code) .. 'm'
end

local function with_styles(pre_codes, text, post_codes)
   if not supported then
      return text
   end

   local pre_style = ''
   for _, code in ipairs(pre_codes) do
      pre_style = pre_style .. escape_sequence(code)
   end

   local post_style = ''
   for _, code in ipairs(post_codes or { 0 }) do
      post_style = post_style .. escape_sequence(code)
   end

   return pre_style .. text .. post_style
end

return {
   format  = with_styles,
   style = {
      reset          = 0,
      bold           = 1,
      italic         = 3,
      underline      = 4,
      reverse        = 7,
      strikethrough  = 9,
   },
   colors = {
      black   = 30,
      red     = 31,
      green   = 32,
      yellow  = 33,
      blue    = 34,
      magenta = 35,
      cyan    = 36,
      white   = 37,
   },
}
