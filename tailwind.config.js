/** @type {import('tailwindcss').Config} */
import daisyui from 'daisyui'
import typography from '@tailwindcss/typography'
import ratio from '@tailwindcss/aspect-ratio'

export default {
  purge: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  darkMode: 'media',
  content: [],
  theme: {
    extend: {}
  },
  daisyui: {
    themes: [
      {
        voron: {
          primary: '#cc000e',
          'base-100': '#2c2f33'
        }
      }
    ]
  },
  plugins: [ratio, typography, daisyui]
}
