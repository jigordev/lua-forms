local utils = {}

function utils.contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

function utils.build_html_attributes(args)
    local html_attributes = {}
    for key, value in pairs(args) do
        table.insert(html_attributes, string.format(" %s='%s'", key, value))
    end
    return table.concat(html_attributes)
end

return utils
