# Lua Forms

lua-forms is a Lua library for creating and validating forms, inspired by WTForms. It provides a flexible framework for defining form fields, applying filters, and validating user input.

## Installation

You can install lua-forms using LuaRocks:

```sh
luarocks install lua-forms
```

## Features

- Define various types of form fields such as text fields, checkboxes, select options, and more.
- Apply filters to input data, such as trimming whitespace, converting to lowercase, etc.
- Validate input using built-in validators like required fields, email validation, number ranges, regular expressions, and custom validation functions.
- Easy integration with Lua applications for handling form submissions and data validation.

## Usage Example

Here's a basic example of how to create and validate a form using lua-forms:

```lua
local lforms = require("lforms")
local fields = require("lforms.fields")
local validators = require("lforms.validators")
local filters = require("lforms.filters")

-- Define a form with fields
local myForm = lforms.Form({
    fields.StringField("username", {
        label = "Username",
        validators = { validators.required(), validators.length(3, 20) },
        filters = { filters.trim }
    }),
    fields.EmailField("email", {
        label = "Email",
        validators = { validators.required(), validators.email() }
    }),
    fields.PasswordField("password", {
        label = "Password",
        validators = { validators.required(), validators.length(6) }
    }),
    fields.SelectField("country", {
        label = "Country",
        choices = { {"us", "United States"}, {"ca", "Canada"}, {"uk", "United Kingdom"} },
        validators = { validators.required() }
    })
})

-- Simulate form submission data
local form_data = {
    username = "john_doe",
    email = "john.doe@example.com",
    password = "securepassword",
    country = "us"
}

-- Validate form data
if myForm(form_data) then
    print("Form data is valid!")
else
    print("Form validation errors:")
    for field, error in pairs(myForm.errors) do
        print(field .. ": " .. error)
    end
end
```

## Available Fields

- `StringField`
- `BooleanField`
- `IntegerField`
- `FloatField`
- `PasswordField`
- `DecimalField`
- `DateField`
- `DateTimeField`
- `TimeField`
- `SelectField`
- `SelectMultipleField`

## Filters

Available filters include `trim`, `lowercase`, `uppercase`, and more for manipulating input data before validation.

## Validators

Use validators like `required`, `length(min, max)`, `email`, `number_range(min, max)`, `regex(pattern)`, and others to enforce validation rules on form fields.

## Contributing

Contributions to lua-forms are welcome! Feel free to open issues or pull requests on the [GitHub repository](https://github.com/jigordev/lua-forms).

## License

This library is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more information.
