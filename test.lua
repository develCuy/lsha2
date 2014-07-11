-- The following script performs some basic tests and shows how to use the
-- library.

-- tests for SHA-2 in Lua 5.1

local lsha2 = require 'lsha2'

-- a few examples from the Web

assert(lsha2.hash224"The quick brown fox jumps over the lazy dog" ==
  "730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525")

assert(lsha2.hash224"" ==
  "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f")

assert(lsha2.hash256"The quick brown fox jumps over the lazy dog" ==
  "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592")

assert(lsha2.hash256"The quick brown fox jumps over the lazy cog" ==
  "e4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be")

assert(lsha2.hash256"" ==
  "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")

assert(lsha2.new256():close() ==
  "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")

assert(lsha2.hash256"123456" ==
  "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92")


-- most other examples here are checked against a "correct" answer
-- given by 'lsha224sum'/'lsha256sum'


-- border cases (sizes around 64 bytes)

assert(lsha2.hash256(string.rep('a', 62) .. '\n') ==
  "290b30a68148b3ee27ab7b744c297a5d986c1011938a09e73058430593bf83f0")
assert(lsha2.hash256(string.rep('a', 63) .. '\n') ==
  "a229eaed30f4991d1fcdab77c70b604efd780502c82be0732b310811dc43b2b3")
assert(lsha2.hash256(string.rep('a', 64) .. '\n') ==
  "44c2336fedab8ff6a85c74c2b94165377b0981f526adb9487895ca6314165e86")
assert(lsha2.hash256(string.rep('a', 65) .. '\n') ==
  "574883a9977284a46845620eaa55c3fa8209eaa3ebffe44774b6eb2dba2cb325")

local x = lsha2.new256()
for i = 1, 65 do x:add('a') end
x:add('\n')
assert(x:close() ==
  "574883a9977284a46845620eaa55c3fa8209eaa3ebffe44774b6eb2dba2cb325")


-- some large files
local function parts (s, j)
  local x = lsha2.new256()
  local i = 1; j = 1
  while i <= #s do
    x:add(s:sub(i, i + j))
    i = i + j + 1
  end
  return x:close()
end

-- 80 lines of 80 '0's each
local s = string.rep('0', 80) .. '\n'
s = string.rep(s, 80)
assert(parts(s, 70) ==
  "736c7a8b17e2cfd44a3267a844db1a8a3e8988d739e3e95b8dd32678fb599139")
assert(parts(s, 7) ==
  "736c7a8b17e2cfd44a3267a844db1a8a3e8988d739e3e95b8dd32678fb599139")
assert(parts(s, #s + 10) ==
  "736c7a8b17e2cfd44a3267a844db1a8a3e8988d739e3e95b8dd32678fb599139")




-- read a file and prints its hash, if given a file name

if arg[1] then
  local file = assert(io.open (arg[1], 'rb'))
  local x = lsha2.new256()
  for b in file:lines(2^12) do
    x:add(b)
  end
  file:close()
  print(x:close())
end

print "ok"
