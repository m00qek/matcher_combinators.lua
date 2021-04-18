require("matcher_combinators.luassert")

local array = require("matcher_combinators.matchers.array")

describe("assertions", function()
   it("simple", function()
      assert.combinators.match({ a = 1, b = 2 }, { a = 1, b = 2, c = 3 })
   end)

   it("nested", function()
      assert.combinators.match({
         a = array.starts_with({ 11, 12 }),
         b = 2,
         c = { x = "X", y = "Y" }
      },
      { a = { 11, 12, 13 }, b = 2, c = { x = "X", y = "Y" , z = "Z" } })
   end)
end)
