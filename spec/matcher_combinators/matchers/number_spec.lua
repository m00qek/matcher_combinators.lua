local number = require('matcher_combinators.matchers.number')
local value = require('matcher_combinators.matchers.value')

local function match(matcher, object)
   local o =  matcher(object)
   return object == o
end

describe("[equals]", function()
   it("when values are equals", function()
      assert.is.True(match(number.equals(-1), -1))
      assert.is.True(match(number.equals(1), 1))
      assert.is.True(match(number.equals(0), 0))
      assert.is.True(match(number.equals(1.1), 1.1))
   end)

   it("when values are NOT equals", function()
      assert.is.False(match(number.equals(-1), nil))
      assert.is.False(match(number.equals(1), 'A'))
      assert.is.False(match(number.equals(0), { }))
      assert.is.False(match(number.equals(1.1), 2.2))
   end)

   it("when values are NOT equals it returns a failure", function()
      assert.is.True(value.is_failure(number.equals(1)(2)))
   end)
end)
