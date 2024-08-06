local class = require("middleclass")
local Form = require("lforms.form")
local fields = require("lforms.fields")

local function test_initialize()
    local field1 = fields.StringField:new("name")
    local field2 = fields.IntegerField:new("age")
    local form = Form:new({ field1, field2 })
    assert(form:count() == 2, "Field count does not match expected")
end

local function test_add_field()
    local form = Form:new({})
    local field = fields.StringField:new("name")
    form:add_field(field)
    assert(form.fields["name"] == field, "Field was not added correctly")
end

local function test_validate_valid_values()
    local field = fields.IntegerField:new("age")
    local form = Form:new({ field })
    local values = { age = 25 }
    local valid = form:validate(values)
    assert(valid, "Validation failed with valid values")
end

local function test_validate_invalid_values()
    local field = fields.IntegerField:new("age")
    local form = Form:new({ field })
    local values = { age = "twenty-five" }
    local valid = form:validate(values)
    assert(not valid, "Validation passed with invalid values")
end

local function test_clear()
    local field = fields.StringField:new("name")
    local form = Form:new({ field })
    form.fields["name"].value = "John"
    form:clear()
    assert(form.fields["name"].value == nil, "Values were not cleared correctly")
end

local function runtests()
    test_initialize()
    test_add_field()
    test_validate_valid_values()
    test_validate_invalid_values()
    test_clear()
    print("All tests passed successfully!")
end

runtests()
