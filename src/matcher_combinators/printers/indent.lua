local indent = {}

function indent.default()
   return { char = ' ', step = 3, current = 0 }
end

function indent.none()
   return { char = ' ', step = 0, current = 0 }
end

function indent.next(indentation)
   return { char = indentation.char, step = indentation.step, current = indentation.current + 1 }
end

function indent.text(indentation)
   local block = ''
   for _ = 1, indentation.step * indentation.current do
      block = block .. indentation.char
   end
   return block
end

return indent
