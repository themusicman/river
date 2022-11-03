module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  extends: [
    'plugin:vue/vue3-essential',
    'standard-with-typescript'
  ],
  overrides: [
    {
      files: ['*.vue'],
      rules: {
        indent: 'off'
      }
    }
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    parser: '@typescript-eslint/parser',
    project: './tsconfig.json',
    extraFileExtensions: ['.vue']
  },
  plugins: [
    'vue'
  ],
  rules: {
    '@typescript-eslint/strict-boolean-expressions': 'off',
    'vue/script-indent': ['error', 2, { baseIndent: 1 }],
    'vue/multi-word-component-names': 'off'
  }
}
