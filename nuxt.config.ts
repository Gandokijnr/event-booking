// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2024-04-03",
  devtools: { enabled: false },
  modules: ["@nuxtjs/tailwindcss", "nuxt-icon", "@nuxt/image"],
  css: ["~/assets/css/tailwind.css"],
  app: {
    head: {
      htmlAttrs: {
        class: "dark",
      },
    },
  },
  runtimeConfig: {
    public: {
      supabaseUrl: process.env.VITE_SUPABASE_URL,
      supabaseKey: process.env.VITE_SUPABASE_ANON_KEY,
    },
  },
});
