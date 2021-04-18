# matcher_combinators.lua
---
Test library for asserting deeply nested data structures

## Installing

Add it using [LuaRocks][luarocks] in the `test_dependencies` entry:

```lua
test_dependencies = { "busted", "luacheck", "matcher_combinators" }
```
## Using 

Here is an example of failing test using it

```lua
require("matcher_combinators.luassert")

local array = require("matcher_combinators.matchers.array")
local predicate = require("matcher_combinators.matchers").predicate

describe("asserting data structures", function()
   it("when they're nested", function()
      assert.combinators.match({
         a = array.starts_with({ 11, 12 }),
         b = 2,
         c = { x = "X", y = "Y" },
         d = predicate(function(actual) return actual >= 0 end),
      }, {
         a = { 11, 15, 13 }, 
         b = 3, 
         c = { x = "X", z = "Z" },
         d = 0 
      })
   end)
end)
```

and the output is

![Screen capture of the above test failing][failure]

### Available matchers

The following modules contain matchers 

```
matcher_combinators.matchers
matcher_combinators.matchers.string
matcher_combinators.matchers.boolean
matcher_combinators.matchers.number
matcher_combinators.matchers.array
matcher_combinators.matchers.table
```

If you miss any matcher please [open an issue][issues].

### Writing your own matchers

Let's say you want to create a matcher for natural numbers. The simplest way to
do it is using the matcher `predicate`:

```lua
local predicate = require("matcher_combinators.matchers").predicate
local is_natural = predicate(function(actual) return actual >= 0 end, "Value is not a natural number!")
```

It is also possible to define it using the internal `matcher` API, which has the 
advantage of having more control of the output in case of a mismatch:

```lua
local base = require("matcher_combinators.matchers.base")
local is_natural = base.matcher(function(actual)
   if actual >= 0 then
      -- when the value matches the return should be the value itself
      return actual
   end

   return value.failure("The number " .. tostring(actual) .. " is not natural!")
end, { name = 'number.is_natural' })
```

** inspired by [matcher-combinators][mc]**

[issues]: https://github.com/m00qek/matcher_combinators.lua/issues
[luarocks]: https://luarocks.org/
[failure]: ./failure.png
[mc]: https://github.com/nubank/matcher-combinators
