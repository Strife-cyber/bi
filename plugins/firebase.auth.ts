export default defineNuxtPlugin(() => {
    if (import.meta.client) {
        useAuth();
    }
});
