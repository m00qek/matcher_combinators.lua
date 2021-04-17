local utils = require('matcher_combinators.utils')

describe("[is_array]", function()
   it('when the value is indeed an array', function()
      assert.is.True(utils.is_array({ 1, 2, 3 }))
   end)

   it('when the value is NOT an array', function()
      assert.is.False(utils.is_array(1))
      assert.is.False(utils.is_array("text"))
      assert.is.False(utils.is_array({ a = 2 }))
   end)
end)

describe("[is_table]", function()
   it('when the value is indeed a table', function()
      assert.is.True(utils.is_table({ a = 1 }))
   end)

   it('when the value is NOT a table', function()
      assert.is.False(utils.is_table(1))
      assert.is.False(utils.is_table("text"))
      assert.is.False(utils.is_table({ 1, 2, 3 }))
   end)
end)