local value = require("matcher_combinators.matchers.value")
local matchers = require("matcher_combinators.matchers")

local function match(matcher, object)
   local o =  matcher(object)
   return object == o
end

describe("[anything]", function()
   it("should match any value", function()
      assert.is.True(match(matchers.anything(), nil))
      assert.is.True(match(matchers.anything(), 1))
      assert.is.True(match(matchers.anything(), true))
      assert.is.True(match(matchers.anything(), "text"))
      assert.is.True(match(matchers.anything(), { }))
   end)
end)

describe("[predicate]", function()
   local odd = matchers.predicate(function(actual)
      return actual % 2 == 1
   end, "EVEN")

   it("when it returns true", function()
      assert.is.True(match(odd, 3))
   end)

   it("when it returns false", function()
      assert.is.False(match(odd, 2))
   end)
end)

