require('matcher_combinators.luassert')

local m = require('matcher_combinators')

assert:set_parameter("TableFormatLevel", -1)

local utils = require('matcher_combinators.utils')

describe("sum", function()
   it('aaaaaaaa', function()
      assert.combinators.match(2, 1)
   end)
   it('NOT works!', function()
      local v = m.matcher({ a = 1, b = { c = 2}, d = { 'A', 'B' } })
--      assert.are.equals(v({        b = 1,        d = { "A" } })['matcher_combinators/mismatched'], 1)
      assert.combinators.match({ a = 1, b = { c = 2}, d = { 'A', 'B' } },
                   {        b = 1,        d = { "A", "B", "C" } })
   end)
end)

