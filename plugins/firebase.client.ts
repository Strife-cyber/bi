import { getAuth } from 'firebase/auth'
import { initializeApp } from 'firebase/app'

export default defineNuxtPlugin(nuxtApp => {
    const config = useRuntimeConfig()

    const firebaseConfig = {
        apiKey: config.public.firebaseApiKey as string,
        authDomain: config.public.firebaseAuthDomain as string,
        projectId: config.public.firebaseProjectId as string,
        storageBucket: config.public.firebaseStorageBucket as string,
        messagingSenderId: config.public.firebaseMessagingSenderId as string,
        appId: config.public.firebaseAppId as string,
        measurementId: config.public.firebaseMeasurementId as string,
        databaseURL: config.public.firebaseDatabaseUrl as string
    }

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);

    return {
        provide: {
        firebase: { app, auth },
        },
    }
});
