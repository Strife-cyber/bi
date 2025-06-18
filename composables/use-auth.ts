import { ref, onMounted } from "vue"
import {
  signInWithPopup,
  signOut,
  onAuthStateChanged,
  type User,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword
} from "firebase/auth"
import { githubProvider, googleProvider, useFirebaseAuth } from "~/services/firebase.service"
import { useCookie } from "#app"

export function useAuth() {
  const user = ref<User | null>(null)
  const userCookie = useCookie<any>('user', { sameSite: 'lax' }) // Client cookie for auth

  let auth: ReturnType<typeof useFirebaseAuth> | null = null

  if (import.meta.client) {
    auth = useFirebaseAuth()

    onAuthStateChanged(auth, (u) => {
      user.value = u
      if (u) {
        // Save only essential info in cookie
        userCookie.value = {
          uid: u.uid,
          email: u.email
        }
      } else {
        userCookie.value = null
      }
    })
  }

  const setCookieFromUser = (u: User | null) => {
    user.value = u
    if (u) {
      userCookie.value = {
        uid: u.uid,
        email: u.email
      }
    } else {
      userCookie.value = null
    }
  }

  const signInWithGoogle = async () => {
    if (!auth) return
    try {
      const result = await signInWithPopup(auth, googleProvider)
      setCookieFromUser(result.user)
    } catch (error) {
      console.error("Google sign-in error: ", error)
    }
  }

  const signInWithGitHub = async () => {
    if (!auth) return
    try {
      const result = await signInWithPopup(auth, githubProvider)
      setCookieFromUser(result.user)
    } catch (error) {
      console.error("GitHub sign-in error: ", error)
    }
  }

  const signUpWithEmail = async (email: string, password: string) => {
    if (!auth) return
    try {
      const result = await createUserWithEmailAndPassword(auth, email, password)
      setCookieFromUser(result.user)
    } catch (error) {
      console.error("Email sign-up error:", error)
    }
  }

  const signInWithEmail = async (email: string, password: string) => {
    if (!auth) return
    try {
      const result = await signInWithEmailAndPassword(auth, email, password)
      setCookieFromUser(result.user)
    } catch (error) {
      console.error("Email sign-in error:", error)
    }
  }

  const logout = async () => {
    if (!auth) return
    await signOut(auth)
    setCookieFromUser(null)
  }

  const getCurrentUser = () => user.value

  return {
    user,
    logout,
    getCurrentUser,
    signInWithEmail,
    signUpWithEmail,
    signInWithGitHub,
    signInWithGoogle
  }
}
