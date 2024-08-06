local filters = {}

function filters.trim(s)
    return s:match("^%s*(.-)%s*$")
end

function filters.lowercase(s)
    return s:lower()
end

function filters.uppercase(s)
    return s:upper()
end

function filters.remove_digits(s)
    return s:gsub("%d", "")
end

function filters.only_digits(s)
    return s:gsub("%D", "")
end

function filters.remove_special_chars(s)
    return s:gsub("[^%w%s]", "")
end

function filters.to_boolean(s)
    local lower = s:lower()
    if lower == "true" or lower == "1" then
        return true
    elseif lower == "false" or lower == "0" then
        return false
    else
        return nil
    end
end

function filters.format_date(s)
    local day, month, year = s:match("(%d%d)/(%d%d)/(%d%d%d%d)")
    if day and month and year then
        return year .. "-" .. month .. "-" .. day
    else
        return s
    end
end

return filters
