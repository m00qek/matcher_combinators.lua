local value = require('matcher_combinators.matchers.value')

describe("Type of value", function()
   it("[failure]", function()
      assert.are.same(
         {['matcher_combinators/failure'] = 1},
         value.failure(1))
   end)

   it("[with_failures]", function()
      assert.are.same(
         {['matcher_combinators/with_failures'] = { }},
         value.with_failures({ }))
   end)

   it("[keep]", function()
      assert.are.same(
         {['matcher_combinators/keep'] = 1},
         value.keep(1))
   end)
end)

describe("Type of failure", function()
   it("[unexpected]", function()
      assert.are.same(
         {['matcher_combinators/failure'] = { unexpected = 1 }},
         value.unexpected(1))
   end)

   it("[missing]", function()
      assert.are.same(
         {['matcher_combinators/failure'] = { missing = 1 }},
         value.missing(1))
   end)

   it("[mismatch]", function()
      assert.are.same(
         {['matcher_combinators/failure'] = { actual = 1, expected = 2 }},
         value.mismatch(2, 1))
   end)
end)

describe("Predicate", function()
   it("[is_failure]", function()
      assert.is.True(value.is_failure({ ['matcher_combinators/failure'] = 1 }))
      assert.is.True(value.is_failure(value.failure(1)))
      assert.is.False(value.is_failure(2))
      assert.is.False(value.is_failure({ }))
   end)

   it("[has_failure]", function()
      assert.is.True(value.has_failure({ ['matcher_combinators/with_failures'] = { } }))
      assert.is.True(value.has_failure(value.with_failures({ })))
      assert.is.False(value.has_failure(2))
      assert.is.False(value.has_failure({ }))
   end)

   it("[should_keep]", function()
      assert.is.True(value.should_keep({ ['matcher_combinators/keep'] = 1 }))
      assert.is.True(value.should_keep(value.keep(1)))
      assert.is.False(value.should_keep(2))
      assert.is.False(value.should_keep({ }))
   end)

   it("[is_match]", function()
      assert.is.True(value.is_match(1))
      assert.is.True(value.is_match({ }))
      assert.is.True(value.is_match(value.keep(2)))
      assert.is.False(value.is_match(value.with_failures({ })))
      assert.is.False(value.is_match(value.failure(2)))
      assert.is.False(value.is_match({ ['matcher_combinators/with_failures'] = { } }))
      assert.is.False(value.is_match({ ['matcher_combinators/failure'] = 1 }))
   end)
end)

describe("[get]", function()
   it("Simple values", function()
      assert.are.equals("text", value.get("text"))
      assert.are.equals(true, value.get(true))
      assert.are.same({ }, value.get({ }))
      assert.are.equals(1, value.get(1))
   end)

   it("matched values", function()
      assert.are.same({ }, value.get(value.with_failures({ })))
      assert.are.same({ }, value.get(value.failure({ })))
      assert.are.same({ }, value.get(value.keep({ })))
   end)
end)
