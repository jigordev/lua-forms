local checkargs = require("checkargs")
local types = require("lforms.types")
local utils = require("lforms.utils")

local validators = {}

function validators.validator(func)
    return function(...)
        local args = { ... }
        return function(value)
            local success, result = func(value, table.unpack(args))
            return success, success and value or result
        end
    end
end

validators.required = validators.validator(function(value)
    return value ~= nil, types.Required
end)

validators.optional = validators.validator(function(value)
    return value == nil, types.Optional
end)

validators.length = validators.validator(function(value, min, max)
    checkargs.check_arg("validators.length", "min", { "number" }, min, true)
    checkargs.check_arg("validators.length", "max", { "number" }, max, true)
    return not (#value < min or #value > max), "Invalid length"
end)

validators.email = validators.validator(function(value)
    return value:match("^[%w.]+@%w+%.%w+$"), "Invalid email address"
end)

validators.eqto = validators.validator(function(value, other)
    return value == other, "Value is not equal to " .. other
end)

validators.number_range = validators.validator(function(value, min, max)
    checkargs.check_arg("validators.number_range", "min", { "number" }, min)
    checkargs.check_arg("validators.number_range", "max", { "number" }, max)
    return value > min and value < max, "Value is not in number range"
end)

validators.any = validators.validator(function(value, list)
    checkargs.check_arg("validators.any", "list", { "table" }, list)
    return utils.contains(list, value), "Value is not in list"
end)

validators.none = validators.validator(function(value, list)
    checkargs.check_arg("validators.none", "list", { "table" }, list)
    return not utils.contains(list, value), "Value is on the list"
end)

validators.regex = validators.validator(function(value, pattern)
    checkargs.check_arg("validators.regex", "pattern", { "string" }, pattern)
    return value:match(pattern), "Not part of the expected pattern"
end)

validators.url = validators.validator(function(value)
    return value:match("^(https?://[%w-_%.%?%.:/%+=&]+)$"), "Invalid URL address"
end)

validators.ipaddr = validators.validator(function(value)
    local is_valid = value:match("^%d+%.%d+%.%d+%.%d+$") ~= nil
    if is_valid then
        local octets = { value:match("(%d+)%.(%d+)%.(%d+)%.(%d+)") }
        for _, octet in ipairs(octets) do
            local num = tonumber(octet)
            if num < 0 or num > 255 then
                is_valid = false
                break
            end
        end
    end
    return is_valid, "Invalid IP address"
end)

return validators
