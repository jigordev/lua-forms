local class = require("middleclass")
local checkargs = require("checkargs")
local utils = require("lforms.utils")
local types = require("lforms.types")

local function validate_type(value, expected_type)
    if type(value) ~= expected_type then
        return false,
            string.format("Invalid type, expected %s but got: %s", expected_type, type(value))
    end
    return true, value
end

local fields = {}

local Field = class("Field")

function Field:initialize(name, options)
    checkargs.check_arg("Field:new", "name", { "string" }, name)
    checkargs.check_arg("Field:new", "options", { "table" }, options, true)

    if options then
        checkargs.check_arg("Field:new", "options.validators", { "table" }, options.validators, true)
        checkargs.check_arg("Field:new", "options.filters", { "table" }, options.filters, true)
        checkargs.check_arg("Field:new", "options.label", { "string" }, options.label, true)
        checkargs.check_arg("Field:new", "options.description", { "string" }, options.description, true)
    end

    self.name = name
    self.options = options or {}
    self.label = self.options.label or ""
    self.description = self.options.description or ""
    self.validators = self.options.validators or {}
    self.filters = self.options.filters or {}
    self.value = nil
    self.errors = {}
    self.base_error = "Error in field '" .. self.name .. "': "

    if self.expected_type then
        self:add_validator(function(value)
            return validate_type(value, self.expected_type)
        end)
    end
end

function Field:__call(value)
    return self:validate(value)
end

function Field:is_valid(value)
    for _, validator in ipairs(self.validators) do
        local success, result = validator(value)

        if result == types.Optional then
            break
        elseif result == types.Required then
            table.insert(self.errors, self.base_error .. "Field is required")
            break
        else
            if not success then
                table.insert(self.errors, self.base_error .. result)
            end
        end
    end

    if next(self.errors) then
        return false
    end

    return true
end

function Field:filter(value)
    for _, filter in ipairs(self.filters) do
        value = filter(value)
    end

    return value
end

function Field:validate(value)
    self.errors = {}

    if not self:is_valid(value) then
        return false, self.errors
    end

    value = self:filter(value)
    self.value = value
    return true, self.value
end

function Field:add_validator(validator)
    checkargs.check_arg("Field:add_validator", "validator", { "function" }, validator)
    table.insert(self.validators, validator)
end

function Field:add_filter(filter)
    checkargs.check_arg("Field:add_filter", "filter", { "function" }, filter)
    table.insert(self.filters, filter)
end

function Field:to_html(args, tag_name, field_type)
    checkargs.check_arg("Field:to_html", "args", { "table" }, args, true)
    checkargs.check_arg("Field:to_html", "tag_name", { "string" }, tag_name, true)
    checkargs.check_arg("Field:to_html", "field_type", { "string" }, field_type, true)

    args = args or {}
    tag_name = tag_name or "input"
    field_type = field_type or "text"

    return string.format("<%s type='%s' name='%s' %s />", tag_name, field_type, self.name,
        utils.build_html_attributes(args))
end

local StringField = class("StringField", Field)
StringField.static.expected_type = "string"

local BooleanField = class("BooleanField", Field)
BooleanField.static.expected_type = "boolean"

function BooleanField:to_html(args)
    return Field.to_html(self, args, "input", "checkbox")
end

local IntegerField = class("IntegerField", Field)
IntegerField.static.expected_type = "number"

function IntegerField:validate(value)
    self:add_validator(function(value)
        if type(value) ~= "number" or math.floor(value) ~= value then
            return false, "Invalid type, expected integer number but got: " .. type(value)
        end
        return true, value
    end)
    return Field.validate(self, value)
end

function IntegerField:to_html(args)
    return Field.to_html(self, args, "input", "number")
end

local FloatField = class("FloatField", Field)
FloatField.static.expected_type = "number"

function FloatField:validate(value)
    self:add_validator(function(value)
        if type(value) ~= "number" or math.floor(value) == value then
            return false, "Invalid type, expected float number but got: " .. type(value)
        end
        return true, value
    end)
    return Field.validate(self, value)
end

function FloatField:to_html(args)
    args = args or {}
    args.step = "any"
    return Field.to_html(self, args, "input", "number")
end

local PasswordField = class("PasswordField", StringField)

function PasswordField:to_html(args)
    return Field.to_html(self, args, "input", "password")
end

local DecimalField = class("DecimalField", Field)
DecimalField.static.expected_type = "number"

function DecimalField:validate(value)
    self:add_validator(function(value)
        if type(value) ~= "number" or value % 1 == 0 then
            return false, "Invalid type, expected decimal number but got: " .. type(value)
        end
        return true, value
    end)
    return Field.validate(self, value)
end

function DecimalField:to_html(args)
    args = args or {}
    args.step = "any"
    return Field.to_html(self, args, "input", "number")
end

local DateField = class("DateField", Field)

function DateField:validate(value)
    self:add_validator(function(value)
        if not value:match("^%d%d%d%d%-%d%d%-%d%d$") then
            return false, "Invalid date format, expected YYYY-MM-DD but got: " .. value
        end
        return true, value
    end)
    return Field.validate(self, value)
end

function DateField:to_html(args)
    return Field.to_html(self, args, "input", "date")
end

local DateTimeField = class("DateTimeField", Field)

function DateTimeField:validate(value)
    self:add_validator(function(value)
        if not value:match("^%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d:%d%d$") then
            return false, "Invalid datetime format, expected YYYY-MM-DDTHH:MM:SS but got: " .. value
        end
        return true, value
    end)
    return Field.validate(self, value)
end

function DateTimeField:to_html(args)
    return Field.to_html(self, args, "input", "datetime-local")
end

local TimeField = class("TimeField", Field)

function TimeField:validate(value)
    self:add_validator(function(value)
        if not value:match("^%d%d:%d%d:%d%d$") then
            return false, "Invalid time format, expected HH:MM:SS but got: " .. value
        end
        return true, value
    end)
    return Field.validate(self, value)
end

function TimeField:to_html(args)
    return Field.to_html(self, args, "input", "time")
end

local SelectField = class("SelectField", Field)

function SelectField:initialize(name, options)
    if type(options) == "table" then
        checkargs.check_arg("SelectField:new", "options.choices", { "table" }, options.choices)
    end
    Field.initialize(self, name, options)
    self.choices = self.options.choices or {}

    local choices = {}
    for _, opt in ipairs(self.options.choices) do
        table.insert(choices, opt[1])
    end

    self:add_validator(function(value)
        if not utils.contains(choices, value) then
            return false, "Value is not among the expected choices: " .. tostring(value)
        end
        return true, value
    end)
end

function SelectField:to_html(args)
    args = args or {}
    local html = "<select name='" .. self.name .. "'" .. utils.build_html_attributes(args) .. ">"
    for _, opt in ipairs(self.choices) do
        html = html .. string.format("<option value='%s'>%s</option>", opt[1], opt[2])
    end
    return html .. "</select>"
end

local SelectMultipleField = class("SelectMultipleField", Field)

function SelectMultipleField:initialize(name, options)
    if type(options) == "table" then
        checkargs.check_arg("SelectMultipleField:new", "options.choices", { "table" }, options.choices)
    end
    Field.initialize(self, name, options)
    self.choices = self.options.choices or {}

    local choices = {}
    for _, opt in ipairs(self.options.choices) do
        table.insert(choices, opt[1])
    end

    self:add_validator(function(value)
        for _, selected in ipairs(value) do
            if not utils.contains(choices, selected) then
                return false, "Value is not among the expected choices: " .. selected
            end
        end
        return true, value
    end)
end

function SelectMultipleField:to_html(args)
    args = args or {}
    local html = "<select multiple name='" .. self.name .. "'" .. utils.build_html_attributes(args) .. ">"
    for _, opt in ipairs(self.choices) do
        html = html .. string.format("<option value='%s'>%s</option>", opt[1], opt[2])
    end
    return html .. "</select>"
end

fields.Field = Field
fields.StringField = StringField
fields.BooleanField = BooleanField
fields.IntegerField = IntegerField
fields.FloatField = FloatField
fields.PasswordField = PasswordField
fields.DecimalField = DecimalField
fields.DateField = DateField
fields.DateTimeField = DateTimeField
fields.TimeField = TimeField
fields.SelectField = SelectField
fields.SelectMultipleField = SelectMultipleField

return fields
