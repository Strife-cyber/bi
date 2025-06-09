<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 flex items-center justify-center p-4 relative overflow-hidden">
    <div class="w-full max-w-md relative z-10">
      <!-- Logo and Header -->
      <div class="text-center mb-8 animate-fade-in-down">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-2xl mb-4 animate-glow animate-morphing">
          <span class="text-white font-bold text-xl">BV</span>
        </div>
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2 text-gradient">Créer un compte</h1>
        <p class="text-gray-600 dark:text-gray-300">Rejoignez la révolution de l'inspection des bâtiments</p>
      </div>

      <!-- Register Form Card -->
      <div class="card-glass rounded-2xl p-8 shadow-2xl animate-scale-in hover-lift">
        <!-- Email Register Form -->
        <form @submit.prevent="registerWithEmail" class="space-y-4">
          <div class="grid grid-cols-2 gap-4">
            <div class="animate-fade-in-up" style="animation-delay: 0.1s">
              <label for="firstName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Prénom
              </label>
              <input
                id="firstName"
                v-model="form.firstName"
                type="text"
                required
                class="w-full px-4 py-3 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-300 hover:border-emerald-300 dark:hover:border-emerald-600"
                placeholder="Jean"
              />
            </div>

            <div class="animate-fade-in-up" style="animation-delay: 0.2s">
              <label for="lastName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Nom
              </label>
              <input
                id="lastName"
                v-model="form.lastName"
                type="text"
                required
                class="w-full px-4 py-3 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-300 hover:border-emerald-300 dark:hover:border-emerald-600"
                placeholder="Dupont"
              />
            </div>
          </div>

          <div class="animate-fade-in-up" style="animation-delay: 0.3s">
            <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Adresse email
            </label>
            <input
              id="email"
              v-model="form.email"
              type="email"
              required
              class="w-full px-4 py-3 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-300 hover:border-emerald-300 dark:hover:border-emerald-600"
              placeholder="jean.dupont@email.com"
            />
          </div>

          <div class="animate-fade-in-up" style="animation-delay: 0.4s">
            <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Mot de passe
            </label>
            <div class="relative">
              <input
                id="password"
                v-model="form.password"
                :type="showPassword ? 'text' : 'password'"
                required
                class="w-full px-4 py-3 pr-12 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-300 hover:border-emerald-300 dark:hover:border-emerald-600"
                placeholder="••••••••"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-emerald-600 transition-colors"
              >
                <span v-if="showPassword" class="text-xl">👁️</span>
                <span v-else class="text-xl">🙈</span>
              </button>
            </div>
            <!-- Password Strength Indicator -->
            <div class="mt-2">
              <div class="flex space-x-1">
                <div v-for="i in 4" :key="i" class="h-1 flex-1 rounded-full transition-all duration-300" :class="getPasswordStrengthColor(i)"></div>
              </div>
              <p class="text-xs text-gray-500 mt-1">{{ passwordStrengthText }}</p>
            </div>
          </div>

          <div class="animate-fade-in-up" style="animation-delay: 0.5s">
            <label for="confirmPassword" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Confirmer le mot de passe
            </label>
            <input
              id="confirmPassword"
              v-model="form.confirmPassword"
              :type="showConfirmPassword ? 'text' : 'password'"
              required
              class="w-full px-4 py-3 pr-12 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-300 hover:border-emerald-300 dark:hover:border-emerald-600"
              :class="{ 'border-red-300': form.confirmPassword && form.password !== form.confirmPassword }"
              placeholder="••••••••"
            />
            <button
              type="button"
              @click="showConfirmPassword = !showConfirmPassword"
              class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-emerald-600 transition-colors"
            >
              <span v-if="showConfirmPassword" class="text-xl">👁️</span>
              <span v-else class="text-xl">🙈</span>
            </button>
            <p v-if="form.confirmPassword && form.password !== form.confirmPassword" class="text-red-500 text-xs mt-1">
              Les mots de passe ne correspondent pas
            </p>
          </div>

          <div class="animate-fade-in-up" style="animation-delay: 0.6s">
            <label class="flex items-start">
              <input
                v-model="form.acceptTerms"
                type="checkbox"
                required
                class="rounded border-gray-300 text-emerald-600 focus:ring-emerald-500 mt-1"
              />
              <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">
                J'accepte les 
                <a href="#" class="text-emerald-600 hover:text-emerald-500 transition-colors hover-scale">conditions d'utilisation</a>
                et la 
                <a href="#" class="text-emerald-600 hover:text-emerald-500 transition-colors hover-scale">politique de confidentialité</a>
              </span>
            </label>
          </div>

          <button
            type="submit"
            :disabled="isLoading || !isFormValid"
            class="w-full btn-primary hover-lift hover-glow animate-fade-in-up disabled:opacity-50 disabled:cursor-not-allowed"
            style="animation-delay: 0.8s"
          >
            <span v-if="isLoading" class="animate-spin mr-2">⏳</span>
            <span v-else class="mr-2">🎉</span>
            {{ isLoading ? 'Création du compte...' : 'Créer mon compte' }}
          </button>
        </form>

        <!-- Divider -->
        <div class="relative m-6">
          <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-gray-200 dark:border-gray-700"></div>
          </div>
          <div class="relative flex justify-center text-sm">
            <span class="px-2 bg-white dark:bg-gray-800 text-gray-500">ou</span>
          </div>
        </div>

        <!-- Social Register Buttons -->
        <div class="space-y-3 mb-6">
          <button @click="registerWithGoogle" class="w-full flex items-center justify-center px-4 py-3 border border-gray-200 dark:border-gray-700 rounded-lg hover:border-emerald-300 dark:hover:border-emerald-600 transition-all duration-300 hover-scale bg-white dark:bg-gray-800 hover-glow group">
            <svg class="w-5 h-5 mr-3 animate-float" viewBox="0 0 24 24">
              <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
              <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
              <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
              <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
            </svg>
            <span class="text-gray-700 dark:text-gray-300 font-medium group-hover:text-emerald-600 transition-colors">S'inscrire avec Google</span>
          </button>

          <button @click="registerWithGitHub" class="w-full flex items-center justify-center px-4 py-3 border border-gray-200 dark:border-gray-700 rounded-lg hover:border-emerald-300 dark:hover:border-emerald-600 transition-all duration-300 hover-scale bg-white dark:bg-gray-800 hover-glow group">
            <svg class="w-5 h-5 mr-3 animate-float" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
            </svg>
            <span class="text-gray-700 dark:text-gray-300 font-medium group-hover:text-emerald-600 transition-colors">S'inscrire avec GitHub</span>
          </button>
        </div>

        <!-- Login Link -->
        <div class="mt-6 text-center animate-fade-in-up" style="animation-delay: 1s">
          <p class="text-gray-600 dark:text-gray-400">
            Déjà un compte ?
            <router-link to="/auth/login" class="text-emerald-600 hover:text-emerald-500 font-medium transition-colors hover-scale">
              Se connecter
            </router-link>
          </p>
        </div>
      </div>

      <!-- Success/Error Messages -->
      <div v-if="message" class="mt-4 p-4 rounded-lg animate-bounce-in" :class="messageType === 'success' ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : 'bg-red-100 text-red-800 border border-red-200'">
        <div class="flex items-center">
          <span class="mr-2">{{ messageType === 'success' ? '✅' : '❌' }}</span>
          {{ message }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'

// Form state
const form = reactive({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  confirmPassword: '',
  acceptTerms: false
})

const showPassword = ref(false)
const showConfirmPassword = ref(false)
const isLoading = ref(false)
const message = ref('')
const messageType = ref('')

// Password strength calculation
const passwordStrength = computed(() => {
  const password = form.password
  let strength = 0
  
  if (password.length >= 8) strength++
  if (/[A-Z]/.test(password)) strength++
  if (/[0-9]/.test(password)) strength++
  if (/[^A-Za-z0-9]/.test(password)) strength++
  
  return strength
})

const passwordStrengthText = computed(() => {
  const strength = passwordStrength.value
  const texts = ['Très faible', 'Faible', 'Moyen', 'Fort', 'Très fort']
  return texts[strength] || 'Très faible'
})

const getPasswordStrengthColor = (index) => {
  const strength = passwordStrength.value
  if (index <= strength) {
    if (strength <= 1) return 'bg-red-400'
    if (strength <= 2) return 'bg-yellow-400'
    if (strength <= 3) return 'bg-blue-400'
    return 'bg-emerald-400'
  }
  return 'bg-gray-200 dark:bg-gray-700'
}

const isFormValid = computed(() => {
  return form.firstName && 
         form.lastName && 
         form.email && 
         form.password && 
         form.confirmPassword && 
         form.password === form.confirmPassword && 
         form.acceptTerms &&
         passwordStrength.value >= 2
})

// Authentication methods
const registerWithGoogle = async () => {
  isLoading.value = true
  try {
    // Simulate Google OAuth
    await new Promise(resolve => setTimeout(resolve, 1500))
    showMessage('Inscription Google réussie !', 'success')
    // Redirect to dashboard
  } catch (error) {
    showMessage('Erreur lors de l\'inscription Google', 'error')
  } finally {
    isLoading.value = false
  }
}

const registerWithGitHub = async () => {
  isLoading.value = true
  try {
    // Simulate GitHub OAuth
    await new Promise(resolve => setTimeout(resolve, 1500))
    showMessage('Inscription GitHub réussie !', 'success')
    // Redirect to dashboard
  } catch (error) {
    showMessage('Erreur lors de l\'inscription GitHub', 'error')
  } finally {
    isLoading.value = false
  }
}

const registerWithEmail = async () => {
  if (!isFormValid.value) {
    showMessage('Veuillez remplir correctement tous les champs', 'error')
    return
  }

  isLoading.value = true
  try {
    // Simulate email registration
    await new Promise(resolve => setTimeout(resolve, 2000))
    showMessage('Compte créé avec succès ! Vérifiez votre email.', 'success')
    // Redirect to login or dashboard
  } catch (error) {
    showMessage('Erreur lors de la création du compte', 'error')
  } finally {
    isLoading.value = false
  }
}

const showMessage = (msg, type) => {
  message.value = msg
  messageType.value = type
  setTimeout(() => {
    message.value = ''
  }, 5000)
}
</script>
