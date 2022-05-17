local string = require('matcher_combinators.matchers.string')
local value = require('matcher_combinators.matchers.value')

local function match(matcher, object)
   local o =  matcher(object)
   return object == o
end

describe("[equals]", function()
   it("when values are equals", function()
      assert.is.True(match(string.equals("text"), "text"))
   end)

   it("when values are NOT equals", function()
      assert.is.False(match(string.equals("text"), "message"))
      assert.is.False(match(string.equals("text"), nil))
      assert.is.False(match(string.equals("1"), 1))
   end)

   it("when values are NOT equals it returns a failure", function()
      assert.is.True(value.is_failure(string.equals("text")("message")))
   end)
end)

describe("[regex]", function()
   it("when the pattern match the value", function()
      assert.is.True(match(string.regex("text%-[0-9]+"), "text-2050"))
   end)
end)
