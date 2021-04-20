require("matcher_combinators.luassert")

local array = require("matcher_combinators.matchers.array")
local matchers = require("matcher_combinators.matchers")

describe("assertions", function()
   it("simple", function()
      assert.combinators.match({ a = 1, b = 2 }, { a = 1, b = 2, c = 3 })
   end)

   it("nested", function()
      assert.combinators.match({
         a = array.starts_with({ 11, 19 }),
         b = 2,
         c = { x = "X", y = "Y" },
         d = matchers.predicate(function(actual) return actual >= 0 end),
      },
      { a = { 11, 12, 13 }, b = 2, c = { x = "X", y = "Y" , z = "Z" }, d = 1 })
   end)
end)
local predicate = require("matcher_combinators.matchers").predicate

describe("asserting data structures", function()
   it("when they're nested", function()
      assert.combinators.match({
         a = array.starts_with({ 11, 12 }),
         b = 2,
         c = { x = "X", y = "Y" },
         d = predicate(function(actual) return actual >= 0 end),
      }, {
         a = { 11, 12, 13 },
         b = 2,
         c = { x = "X", y = "Y", z = "Z" },
         d = 1
      })
   end)
end)
