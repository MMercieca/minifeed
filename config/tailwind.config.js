const defaultTheme = require('tailwindcss/defaultTheme')
// https://colors.muz.li/palette/ffa822/134e6f/ff6150/1ac0c6/dee0e6

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'white': '#ffffff',
        'light-blue': '#1ac0c6',
        'dark-blue': '#12577e',
        'orange': '#ff6150',
        'dark-orange': '#e75848',
        'really-dark-orange': '#d2220f',
        'yellow': '#ffa822',
        'gray': '#dee0e6',
        'light-gray': '#f9fafb'
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}