local fields = require("lforms.fields")

local function test_string_field()
    local field = fields.StringField:new("name")
    local success, value = field("John")
    assert(success, "StringField failed to validate 'John'")
    assert(value == "John", "StringField did not return the correct value")
end

local function test_boolean_field()
    local field = fields.BooleanField:new("active")
    local success, value = field(true)
    assert(success, "BooleanField failed to validate 'true'")
    assert(value == true, "BooleanField did not return the correct value")
end

local function test_integer_field()
    local field = fields.IntegerField:new("age")
    local success, value = field(25)
    assert(success, "IntegerField failed to validate '25'")
    assert(value == 25, "IntegerField did not return the correct value")
end

local function test_float_field()
    local field = fields.FloatField:new("price")
    local success, value = field(19.99)
    assert(success, "FloatField failed to validate '19.99'")
    assert(value == 19.99, "FloatField did not return the correct value")
end

local function test_password_field()
    local field = fields.PasswordField:new("password")
    local success, value = field("secret")
    assert(success, "PasswordField failed to validate 'secret'")
    assert(value == "secret", "PasswordField did not return the correct value")
end

local function test_decimal_field()
    local field = fields.DecimalField:new("decimal")
    local success, value = field(3.14)
    assert(success, "DecimalField failed to validate '3.14'")
    assert(value == 3.14, "DecimalField did not return the correct value")
end

local function test_date_field()
    local field = fields.DateField:new("date")
    local success, value = field("2023-12-31")
    assert(success, "DateField failed to validate '2023-12-31'")
    assert(value == "2023-12-31", "DateField did not return the correct value")
end

local function test_datetime_field()
    local field = fields.DateTimeField:new("datetime")
    local success, value = field("2023-12-31T23:59:59")
    assert(success, "DateTimeField failed to validate '2023-12-31T23:59:59'")
    assert(value == "2023-12-31T23:59:59", "DateTimeField did not return the correct value")
end

local function test_time_field()
    local field = fields.TimeField:new("time")
    local success, value = field("23:59:59")
    assert(success, "TimeField failed to validate '23:59:59'")
    assert(value == "23:59:59", "TimeField did not return the correct value")
end

local function test_select_field()
    local field = fields.SelectField:new("choice", { choices = { { 1, "One" }, { 2, "Two" } } })
    local success, value = field(1)
    assert(success, "SelectField failed to validate '1'")
    assert(value == 1, "SelectField did not return the correct value")
end

local function test_select_multiple_field()
    local field = fields.SelectMultipleField:new("choices", { choices = { { 1, "One" }, { 2, "Two" } } })
    local success, value = field({ 1, 2 })
    assert(success, "SelectMultipleField failed to validate '{1, 2}'")
    assert(value[1] == 1 and value[2] == 2, "SelectMultipleField did not return the correct values")
end

local function runtests()
    test_string_field()
    test_boolean_field()
    test_integer_field()
    test_float_field()
    test_password_field()
    test_decimal_field()
    test_date_field()
    test_datetime_field()
    test_time_field()
    test_select_field()
    test_select_multiple_field()
    print("All tests passed successfully!")
end

runtests()
