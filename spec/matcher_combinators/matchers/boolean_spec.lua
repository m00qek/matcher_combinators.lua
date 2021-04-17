local boolean = require('matcher_combinators.matchers.boolean')
local value = require('matcher_combinators.matchers.value')

local function match(matcher, object)
   local o =  matcher(object)
   return object == o
end

describe("[equals]", function()
   it("when values are equals", function()
      assert.is.True(match(boolean.equals(true), true))
      assert.is.True(match(boolean.equals(false), false))
   end)

   it("when values are NOT equals", function()
      assert.is.False(match(boolean.equals(true), false))
      assert.is.False(match(boolean.equals(false), true))
      assert.is.False(match(boolean.equals(true), 1))
      assert.is.False(match(boolean.equals(true), nil))
   end)

   it("when values are NOT equals it returns a failure", function()
      assert.is.True(value.is_failure(boolean.equals(true)(false)))
   end)
end)

describe("[truthy]", function()
   it("when values are nil or false", function()
      assert.is.False(match(boolean.truthy(), nil))
      assert.is.False(match(boolean.truthy(), false))
   end)

   it("when values are NOT nil of false", function()
      assert.is.True(match(boolean.truthy(), true))
      assert.is.True(match(boolean.truthy(), 0))
      assert.is.True(match(boolean.truthy(), { }))
      assert.is.True(match(boolean.truthy(), "text"))
   end)

   it("when values are NOT truthy it returns a failure", function()
      assert.is.True(value.is_failure(boolean.truthy()(nil)))
      assert.is.True(value.is_failure(boolean.truthy()(false)))
   end)
end)

describe("[falsey]", function()
   it("when values are nil or false", function()
      assert.is.True(match(boolean.falsey(), nil))
      assert.is.True(match(boolean.falsey(), false))
   end)

   it("when values are NOT nil of false", function()
      assert.is.False(match(boolean.falsey(), true))
      assert.is.False(match(boolean.falsey(), 0))
      assert.is.False(match(boolean.falsey(), { }))
      assert.is.False(match(boolean.falsey(), "text"))
   end)

   it("when values are NOT falsey it returns a failure", function()
      assert.is.True(value.is_failure(boolean.falsey()(1)))
   end)
end)
