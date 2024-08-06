local filters = require("lforms.filters")

local function test_trim()
    assert(filters.trim("  hello  ") == "hello", "Trim failed")
    assert(filters.trim("   lua rocks   ") == "lua rocks", "Trim failed")
end

local function test_lowercase()
    assert(filters.lowercase("Hello") == "hello", "Lowercase failed")
    assert(filters.lowercase("LuA RoCKs") == "lua rocks", "Lowercase failed")
end

local function test_uppercase()
    assert(filters.uppercase("hello") == "HELLO", "Uppercase failed")
    assert(filters.uppercase("lua rocks") == "LUA ROCKS", "Uppercase failed")
end

local function test_remove_digits()
    assert(filters.remove_digits("abc123def456") == "abcdef", "Remove digits failed")
    assert(filters.remove_digits("123lua456rocks789") == "luarocks", "Remove digits failed")
end

local function test_only_digits()
    assert(filters.only_digits("abc123def456") == "123456", "Only digits failed")
    assert(filters.only_digits("123lua456rocks789") == "123456789", "Only digits failed")
end

local function test_remove_special_chars()
    assert(filters.remove_special_chars("abc$%123*def#@") == "abc123def", "Remove special chars failed")
    assert(filters.remove_special_chars("lua-rocks!@#2023") == "luarocks2023", "Remove special chars failed")
end

local function test_to_boolean()
    assert(filters.to_boolean("true") == true, "To boolean failed")
    assert(filters.to_boolean("false") == false, "To boolean failed")
    assert(filters.to_boolean("1") == true, "To boolean failed")
    assert(filters.to_boolean("0") == false, "To boolean failed")
    assert(filters.to_boolean("other") == nil, "To boolean failed")
end

local function test_format_date()
    assert(filters.format_date("31/12/2023") == "2023-12-31", "Format date failed")
    assert(filters.format_date("2023-12-31") == "2023-12-31", "Format date failed")
end

local function runtests()
    test_trim()
    test_lowercase()
    test_uppercase()
    test_remove_digits()
    test_only_digits()
    test_remove_special_chars()
    test_to_boolean()
    test_format_date()
    print("All tests passed successfully!")
end

runtests()
