local class = require("middleclass")
local checkargs = require("checkargs")
local fields = require("lforms.fields")
local utils = require("lforms.utils")

local Form = class("Form")

function Form:initialize(fields)
    checkargs.check_arg("Form:new", "fields", { "table" }, fields, true)
    self.fields = {}
    self.errors = {}
    for _, field in ipairs(fields) do
        self:add_field(field)
    end
end

function Form:__call(values)
    checkargs.check_arg("Form:__call", "values", { "table" }, values)
    return self:validate(values)
end

function Form:validate(values)
    checkargs.check_arg("Form:validate", "values", { "table" }, values)
    self.errors = {}
    for name, field in pairs(self.fields) do
        local value = values[name]
        local success, result = field:validate(value)
        if not success then
            self.errors[name] = result
        end
    end

    return next(self.errors) == nil
end

function Form:add_field(field)
    checkargs.check_arg("Form:add_field", "field", { "table" }, field)

    if not field.isInstanceOf or not field:isInstanceOf(fields.Field) then
        error("Error in Form:add_field: Field is not a instance of Field")
    end

    if self.fields[field.name] then
        error("Error in Form:add_field: Field name is already in use: " .. field.name)
    end

    self.fields[field.name] = field
end

function Form:remove_field(name)
    checkargs.check_arg("Form:remove_field", "name", { "string" }, name)
    self.fields[name] = nil
end

function Form:clear()
    for _, field in pairs(self.fields) do
        field.value = nil
    end
end

function Form:reset()
    self.errors = {}
    self:clear()
end

function Form:get(name)
    checkargs.check_arg("Form:get", "name", { "string" }, name)

    if self.fields[name] then
        return self.fields[name].value
    else
        error("Error in Form:get: Field '" .. name .. "' not found.")
    end
end

function Form:get_or_default(name, default)
    checkargs.check_arg("Form:get_or_default", "name", { "string" }, name)
    return self.fields[name] ~= nil and self.fields[name].value or default
end

function Form:get_all()
    local values = {}
    for name, field in pairs(self.fields) do
        values[name] = field.value
    end
    return values
end

function Form:count()
    local count = 0
    for _, _ in pairs(self.fields) do
        count = count + 1
    end
    return count
end

function Form:to_html(args)
    args = args or {}
    local form = "<form " .. utils.build_html_attributes(args) .. ">\n"

    local html = {}
    for _, field in pairs(self.fields) do
        html[#html + 1] = field:to_html()
    end

    form = form .. table.concat(html, "\n")
    form = form .. "</form>"
    return form
end

return Form
