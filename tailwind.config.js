/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ['./index.html'],
    theme: {
        extend: {
            fontFamily: {
                serif: ['"Playfair Display"', 'serif'],
                sans: ['Inter', 'sans-serif'],
                mono: ['"JetBrains Mono"', 'monospace'],
            },
            colors: {
                brandBg: 'rgb(246 246 244 / <alpha-value>)',
                brandDark: 'rgb(17 17 17 / <alpha-value>)',
                brandBlue: 'rgb(15 58 104 / <alpha-value>)',
                brandRed: 'rgb(233 59 59 / <alpha-value>)'
            }
        }
    },
    plugins: [],
}
