local validators = require("lforms.validators")
local types = require("lforms.types")

local function test_required()
    local validator = validators.required()
    local success, _ = validator("not empty")
    assert(success, "Validator 'required' failed to validate 'not empty'")
    success, _ = validator(nil)
    assert(not success, "Validator 'required' should fail to validate 'nil'")
end

local function test_optional()
    local validator = validators.optional()
    local success, result = validator(nil)
    assert(success, "Validator 'optional' failed to validate 'nil'")
    assert(result == types.Optional, "Validator 'optional' did not return the correct value")
end

local function test_length()
    local validator = validators.length(5, 10)
    local success, _ = validator("short")
    assert(success, "Validator 'length' failed to validate 'short'")
    success, _ = validator("very very long")
    assert(not success, "Validator 'length' should fail to validate 'very very long'")
end

local function test_email()
    local validator = validators.email()
    local success, _ = validator("test@example.com")
    assert(success, "Validator 'email' failed to validate 'test@example.com'")
    success, _ = validator("invalid-email")
    assert(not success, "Validator 'email' should fail to validate 'invalid-email'")
end

local function test_eqto()
    local validator = validators.eqto("expected")
    local success, _ = validator("expected")
    assert(success, "Validator 'eqto' failed to validate 'expected'")
    success, _ = validator("unexpected")
    assert(not success, "Validator 'eqto' should fail to validate 'unexpected'")
end

local function test_number_range()
    local validator = validators.number_range(1, 10)
    local success, _ = validator(5)
    assert(success, "Validator 'number_range' failed to validate '5'")
    success, _ = validator(0)
    assert(not success, "Validator 'number_range' should fail to validate '0'")
end

local function test_any()
    local validator = validators.any({ "a", "b", "c" })
    local success, _ = validator("a")
    assert(success, "Validator 'any' failed to validate 'a'")
    success, _ = validator("d")
    assert(not success, "Validator 'any' should fail to validate 'd'")
end

local function test_none()
    local validator = validators.none({ "a", "b", "c" })
    local success, _ = validator("d")
    assert(success, "Validator 'none' failed to validate 'd'")
    success, _ = validator("a")
    assert(not success, "Validator 'none' should fail to validate 'a'")
end

local function test_regex()
    local validator = validators.regex("^%d+$")
    local success, _ = validator("12345")
    assert(success, "Validator 'regex' failed to validate '12345'")
    success, _ = validator("abcde")
    assert(not success, "Validator 'regex' should fail to validate 'abcde'")
end

local function test_url()
    local validator = validators.url()
    local success, _ = validator("http://example.com")
    assert(success, "Validator 'url' failed to validate 'http://example.com'")
    success, _ = validator("invalid-url")
    assert(not success, "Validator 'url' should fail to validate 'invalid-url'")
end

local function test_ipaddr()
    local validator = validators.ipaddr()
    local success, _ = validator("192.168.1.1")
    assert(success, "Validator 'ipaddr' failed to validate '192.168.1.1'")
    success, _ = validator("999.999.999.999")
    assert(not success, "Validator 'ipaddr' should fail to validate '999.999.999.999'")
end

local function runtests()
    test_required()
    test_optional()
    test_length()
    test_email()
    test_eqto()
    test_number_range()
    test_any()
    test_none()
    test_regex()
    test_url()
    test_ipaddr()
    print("All tests passed successfully!")
end

runtests()
