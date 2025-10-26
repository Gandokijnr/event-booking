// tailwind.config.ts
// no import needed; export the config object directly

export default {
  content: [
    "./app.vue",
    "./pages/**/*.{vue,ts,js}",
    "./components/**/*.{vue,ts,js}",
    "./layouts/**/*.{vue,ts,js}",
    "./composables/**/*.{ts,js}",
    "./server/**/*.{ts,js}",
    "./nuxt.config.{ts,js}",
  ],
  darkMode: "class",
  theme: {
    extend: {
      fontFamily: {
        display: ["var(--font-display)", "sans-serif"],
        sans: ["var(--font-sans)", "sans-serif"],
      },
      backgroundImage: {
        "gradient-radial": "radial-gradient(var(--tw-gradient-stops))",
      },
    },
  },
  plugins: [],
} as const;
