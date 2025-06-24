import tailwindcss from "@tailwindcss/vite";

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },

  modules: [
    '@nuxt/content',
    '@nuxt/eslint',
    '@nuxt/fonts',
    '@nuxt/icon',
    '@nuxt/image',
    '@nuxt/scripts',
    '@nuxt/ui',
    '@nuxtjs/cloudinary'
  ],

  css: ['~/assets/css/main.css'],

  vite: {
    plugins: [
      tailwindcss()
    ]
  },

  runtimeConfig: {
    firebaseSecret: '',

    cloudinaryCloudName: process.env.CLOUDINARY_CLOUD_NAME,
    // The secret and key should remain private (server-only)
    cloudinaryApiKey: process.env.CLOUDINARY_API_KEY,
    cloudinaryApiSecret: process.env.CLOUDINARY_API_SECRET,

    public: {
      firebaseApiKey: process.env.FIREBASE_API_KEY,
      firebaseAuthDomain: process.env.FIREBASE_AUTH_DOMAIN,
      firebaseProjectId: process.env.FIREBASE_PROJECT_ID,
      firebaseStorageBucket: process.env.FIREBASE_STORAGE_BUCKET,
      firebaseMessageSenderId: process.env.FIREBASE_MESSAGE_SENDER_ID,
      firebaseAppId: process.env.FIREBASE_APP_ID,
      firebaseMeasurementId: process.env.FIREBASE_MEASUREMENT_ID,
      firebaseDatabaseUrl: process.env.FIREBASE_DATABASE_URL
    },

    app: {
      head: {
        script: [
          { src: 'https://widget.cloudinary.com/v2.0/global/all.js', defer: true },
        ]
      }
    }
  },

  plugins: [
    '~/plugins/firebase.client.ts',
    '~/plugins/firebase.auth.ts'
  ]
})
