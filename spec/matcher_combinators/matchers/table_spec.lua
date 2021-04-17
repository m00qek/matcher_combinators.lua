local table = require('matcher_combinators.matchers.table')
local number = require('matcher_combinators.matchers.number')
local value = require('matcher_combinators.matchers.value')

assert:set_parameter("TableFormatLevel", -1)

local n = number.equals

local missing = value.missing
local mismatch = value.mismatch
local unexpected = value.unexpected
local with_failures = value.with_failures
local absent = table.absent

describe("[contains]", function()
   it("when trying to compare do a value that is not a table", function()
      assert.are.same(
         mismatch({ a = n(1), b = n(2) }, "something"),
         table.contains({ a = n(1), b = n(2) })("something"))
   end)

   it("it is equal", function()
      local t = { a = 1, b = 2 }
      assert.are.same(t, table.contains({ a = n(1), b = n(2) })(t))
   end)

   it("it contains extra keys", function()
      local t = { a = 1, b = 2, c = 3 }
      assert.are.same(t, table.contains({ a = n(1), b = n(2) })(t))
   end)

   it("it lacks some keys", function()
      assert.are.same(
         with_failures({ a = 1, b = missing(n(2)) }),
         table.contains({ a = n(1), b = n(2) })({ a = 1 }))

      assert.are.same(
         with_failures({ a = missing(n(1)), b = missing(n(2)) }),
         table.contains({ a = n(1), b = n(2) })({ }))
   end)

   it("it forbids a key", function()
      local t = { a = 1, b = 2 }
      assert.are.same(
         table.contains({ a = n(1), b = absent() })(t),
         with_failures({ a = 1, b = unexpected(2) }))
   end)
end)
