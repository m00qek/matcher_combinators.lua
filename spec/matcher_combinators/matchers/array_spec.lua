local array = require('matcher_combinators.matchers.array')
local boolean = require('matcher_combinators.matchers.boolean')
local number = require('matcher_combinators.matchers.number')
local value = require('matcher_combinators.matchers.value')

local function assert_success(matcher, object)
   local result = matcher(object)
   assert.are.same(result, object)
end

assert:set_parameter("TableFormatLevel", -1)

local n = number.equals
local b = boolean.equals

local keep = value.keep
local missing = value.missing
local unexpected = value.unexpected
local mismatch = value.mismatch
local with_failures = value.with_failures

describe("[equals]", function()
   it("when trying to compare to a value that is not an array", function()
      assert.are.same(
         array.equals({ n(1), n(2) })("something"),
         mismatch({ n(1), n(2) }, "something"))
   end)

   it("knows how to handle 'false' value", function()
      local a = { false, 1 }
      assert.are.same(a, array.equals({ b(false), n(1) })(a))
   end)

   it("when values are equals", function()
      assert_success(array.equals({ n(1), n(2), n(3) }), { 1, 2, 3 })
   end)

   local matcher = array.equals({ n(1), n(2), n(3) })

   it("when it has missing values", function()
      assert.are.same(
         with_failures({ keep(1), keep(2), missing(n(3)) }),
         matcher({ 1, 2 }))
   end)

   it("when it has unexpected values", function()
      assert.are.same(
         with_failures({ keep(1), keep(2), keep(3), unexpected(4) }),
         matcher({ 1, 2, 3, 4 }))
   end)

   it("when it has mismatched values values", function()
      assert.are.same(
         with_failures({ keep(1), keep(2), mismatch(3, 9) }),
         matcher({ 1, 2, 9 }))

      assert.are.same(
         with_failures({ mismatch(1, 9), keep(2), keep(3) }),
         matcher({ 9, 2, 3 }))

      assert.are.same(
         with_failures({ keep(1), mismatch(2, 9), keep(3) }),
         matcher({ 1, 9, 3 }))
   end)

   it("when it has multiple failure types", function()
      assert.are.same(
         with_failures({ mismatch(1, 9), keep(2), keep(3) }),
         matcher({ 9, 2, 3 }))

      assert.are.same(
         with_failures({ keep(1), keep(2), mismatch(3, 9), unexpected(8) }),
         matcher({ 1, 2, 9, 8}))

      assert.are.same(
         with_failures({ keep(1), mismatch(2, 9), missing(n(3)) }),
         matcher({ 1, 9 }))
   end)
end)

describe("[starts_with]", function()
   it("when trying to compare to a value that is not an array", function()
      assert.are.same(
         array.starts_with({ n(1), n(2) })("something"),
         mismatch({ n(1), n(2) }, "something"))
   end)

   it("when actual is equal expected", function()
      assert_success(array.starts_with({ n(1), n(2) }), { 1, 2 })
   end)

   it("when actual starts_with expected", function()
      assert_success(array.starts_with({ n(1), n(2) }), { 1, 2, 3, 4, 5 })
   end)

   local matcher = array.starts_with({ n(1), n(2) })

   it("when it has missing values", function()
      assert.are.same(
         with_failures({ keep(1), missing(n(2)) }),
         matcher({ 1 }))
   end)

   it("when it has mismatched values values", function()
      assert.are.same(
         with_failures({ keep(1), mismatch(2, 9) }),
         matcher({ 1, 9 }))

      assert.are.same(
         with_failures({ mismatch(1, 9), keep(2) }),
         matcher({ 9, 2, 3 }))
   end)

   it("when it has multiple failure types", function()
      assert.are.same(
         with_failures({ mismatch(1, 9), keep(2) }),
         matcher({ 9, 2, 3 }))

      assert.are.same(
         with_failures({ keep(1), mismatch(2, 9) }),
         matcher({ 1, 9 }))
   end)
end)

describe("[ends_with]", function()
   it("when actual is equal expected", function()
      assert_success(array.ends_with({ n(8), n(9) }), { 8, 9 })
   end)


   it("when actual ends_with expected", function()
      assert_success(array.ends_with({ n(8), n(9) }), { 5, 6, 7, 8, 9 })
   end)

   local matcher = array.ends_with({ n(8), n(9) })

   it("when it has missing values", function()
      assert.are.same(
         with_failures({ missing(n(8)), keep(9) }),
         matcher({ 9 }))
   end)

   it("when it has mismatched values", function()
      assert.are.same(
         with_failures({ keep(8), mismatch(9, 2) }),
         matcher({ 8, 2 }))

      assert.are.same(
         with_failures({ mismatch(8, 1), keep(9) }),
         matcher({ 7, 1, 9 }))
   end)

   it("when it has multiple failure types", function()
      assert.are.same(
         with_failures({ missing(n(8)), mismatch(9, 1) }),
         matcher({ 1 }))
   end)
end)

describe("[empty]", function()
   it("when comparing against a non array value", function()
      assert.are.same(mismatch({}, 1), array.empty()(1))
   end)

   it("when array is empty", function()
      assert.are.same({}, array.empty()({}))
   end)

   it("when array is not empty", function()
      assert.are.same(
         with_failures({ unexpected(1), unexpected(2) }),
         array.empty()({ 1, 2 }))
   end)
end)

describe("[contains]", function()
   it("when comparing against a non array value", function()
      assert.are.same(mismatch({ n(1) }, 1), array.contains({ n(1) })(1))
   end)

   it("when expected is empty", function()
      assert.are.same({ 1, 2 }, array.contains({ })({ 1, 2 }))
   end)

   it("when actual is empty", function()
      assert.are.same(
         with_failures({ missing(n(1)) }),
         array.contains({ n(1) })({ }))
   end)

   it("when actual does not contain all expected values", function()
      assert.are.same(
         with_failures({ missing(n(1)) }),
         array.contains({ n(1), n(2) })({ 2, 3 }))
   end)

   it("when actual contains all expected values", function()
      assert.are.same({ 2, 1 }, array.contains({ n(1) })({ 2, 1 }))
   end)
end)
