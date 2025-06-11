import { getDatabase } from "firebase/database";
import { getFirestore } from "firebase/firestore";
import { getAnalytics } from "firebase/analytics";
import { GithubAuthProvider, GoogleAuthProvider, getAuth } from "firebase/auth";

// Export functions instead of accessing useNuxtApp at top level
export function useFirebaseAuth() {
  const nuxtApp = useNuxtApp();
  if (!nuxtApp.$firebase?.app) throw new Error("Firebase not initialized");
  return getAuth(nuxtApp.$firebase.app);
}

export function useFirebaseAnalytics() {
  if (import.meta.client) {
    const { $firebase } = useNuxtApp();
    return getAnalytics($firebase.app);
  }
  return undefined;
}

export function useFirebaseDatabase() {
  const nuxtApp = useNuxtApp();
  if (!nuxtApp.$firebase?.app) throw new Error("Firebase not initialized");
  return getDatabase(nuxtApp.$firebase.app);
}

export function useFirebaseFirestore() {
  const nuxtApp = useNuxtApp();
  if (!nuxtApp.$firebase?.app) throw new Error("Firebase not initialized");
  return getFirestore(nuxtApp.$firebase.app);
}

export const githubProvider = new GithubAuthProvider();
export const googleProvider = new GoogleAuthProvider();
