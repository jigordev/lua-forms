local utils = require("lforms.utils")

local function test_contains()
    local tbl = { 1, 2, 3, 4, 5 }
    assert(utils.contains(tbl, 3), "Contains failed: should find existing value")
    assert(not utils.contains(tbl, 6), "Contains failed: should not find non-existing value")
end

local function test_build_html_attributes()
    local args = { class = "btn", id = "submit-btn", disabled = true }
    local attrs = utils.build_html_attributes(args)
    assert(
        attrs:match("class='btn'") ~= nil and
        attrs:match("id='submit%-btn'") ~= nil and
        attrs:match("disabled='true'") ~= nil,
        "Build HTML attributes failed"
    )
end

local function runtests()
    test_contains()
    test_build_html_attributes()
    print("All tests passed successfully!")
end

runtests()
