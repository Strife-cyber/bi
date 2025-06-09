import { ref } from "vue";
import { useFirebaseAuth, googleProvider, githubProvider } from "~/services/firebase.service";
import { 
    signInWithPopup, signOut, onAuthStateChanged, type User, 
    createUserWithEmailAndPassword, signInWithEmailAndPassword 
} from "firebase/auth";

const user = ref<User | null>(null);

export function useAuth() {
    const user = ref<User | null>(null);
    const auth = useFirebaseAuth();

    const signInWithGoogle = async () => {
        try {
            const result = await signInWithPopup(auth, googleProvider);
            user.value = result.user;
        } catch (error) {
            console.error("Google sign-in error: ", error);
        }
    }

    const signInWithGitHub = async () => {
        try {
            const result = await signInWithPopup(auth, githubProvider);
            user.value = result.user;
        } catch (error) {
            console.error("GitHub sign-in error: ", error);
        }
    }

    const signUpWithEmail = async (email: string, password: string) => {
        try {
            const result = await createUserWithEmailAndPassword(auth, email, password);
            user.value = result.user;
        } catch (error) {
            console.error("Email sign-up error:", error);
        }
    }

    const signInWithEmail = async (email: string, password: string) => {
        try {
            const result = await signInWithEmailAndPassword(auth, email, password);
            user.value = result.user;
        } catch (error) {
            console.error("Email sign-in error:", error);
        }
    };

    const logout = async () => {
        await signOut(auth);
        user.value = null;
    }

    const getCurrentUser = () => user.value;

    // keep user in sync
    onAuthStateChanged(auth, (u) => {
        user.value = u;
    });

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
