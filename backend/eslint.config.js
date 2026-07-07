import typescriptEslint from "@typescript-eslint/eslint-plugin";
import typescriptParser from "@typescript-eslint/parser";
import tsdocPlugin from "eslint-plugin-tsdoc";
import jsdocPlugin from "eslint-plugin-jsdoc";

export default [
  {
    files: ["src/**/*.ts"],
    languageOptions: {
      parser: typescriptParser,
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
      },
    },
    plugins: {
      "@typescript-eslint": typescriptEslint,
      "tsdoc": tsdocPlugin,
      "jsdoc": jsdocPlugin,
    },
    rules: {
      "semi": ["error", "always"],
      "quotes": ["error", "double", { "avoidEscape": true }],
      "no-unused-vars": "off",
      "@typescript-eslint/no-unused-vars": ["warn", { "argsIgnorePattern": "^_" }],
      "tsdoc/syntax": "error",
      "jsdoc/require-jsdoc": [
        "error",
        {
          "publicOnly": true,
          "require": {
            "FunctionDeclaration": true,
            "MethodDefinition": true,
            "ClassDeclaration": true,
            "ArrowFunctionExpression": true,
            "FunctionExpression": true
          }
        }
      ]
    },
  },
];
