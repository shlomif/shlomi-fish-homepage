return {
    "parser": "@typescript-eslint/parser",
    "plugins": ["@typescript-eslint"],
    "extends": ["eslint:recommended", "plugin:@typescript-eslint/recommended",
        "plugin:prettier/recommended"],
    "parserOptions": {
        "ecmaVersion": 6,
        "sourceType": "module"
    },
    "rules": {
        "@typescript-eslint/camelcase": 0,
        "@typescript-eslint/class-name-casing": 0,
        "@typescript-eslint/explicit-function-return-type": 0,
        "@typescript-eslint/no-empty-function": 0,
        "@typescript-eslint/no-explicit-any": 0,
        "@typescript-eslint/no-inferrable-types": 0,
        "@typescript-eslint/no-this-alias": 0,
        "@typescript-eslint/no-unused-vars": 0,
        "@typescript-eslint/no-use-before-define": 0,
        "arrow-return-shorthand": 0,
        "class-name": 0,
        "max-classes-per-file": 0,
        "no-bitwise": 0,
        "no-conditional-assignment": 0,
        "no-console": 0,
        "no-constant-condition": 0,
        "no-inner-declarations": 0,
        "no-string-throw": 0,
        "no-this-assignment": 0,
        "no-undef": 0,
        "no-useless-escape": 0,
        "prefer-const": 0,
        "prefer-template": 0,
        "prettier/prettier": [2,
            {
                "arrowParens": "always",
                "tabWidth": 4,
                "trailingComma": "all"
            }],
        "quotemark": 0,
        "variable-name": 0
    }
}
