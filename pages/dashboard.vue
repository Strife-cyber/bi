<template>
  <div class="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-100 dark:from-gray-900 dark:via-slate-900 dark:to-indigo-950">
    <Header />
    
    <!-- Background decoration -->
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div class="absolute -top-40 -right-40 w-80 h-80 bg-gradient-to-br from-blue-400/20 to-purple-600/20 rounded-full blur-3xl"></div>
      <div class="absolute -bottom-40 -left-40 w-80 h-80 bg-gradient-to-tr from-emerald-400/20 to-cyan-600/20 rounded-full blur-3xl"></div>
    </div>

    <div class="relative pt-24 pb-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-7xl mx-auto space-y-8">
        
        <!-- Welcome Section -->
        <div class="relative overflow-hidden">
          <div class="bg-gradient-to-r from-emerald-500 via-teal-500 to-cyan-500 rounded-3xl p-8 shadow-2xl shadow-emerald-500/25">
            <div class="absolute inset-0 bg-gradient-to-r from-emerald-600/90 via-teal-600/90 to-cyan-600/90 rounded-3xl"></div>
            <div class="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full -translate-y-32 translate-x-32 blur-3xl"></div>
            
            <div class="relative grid lg:grid-cols-3 gap-8 items-center">
              <div class="lg:col-span-2 space-y-4 text-white">
                <div class="flex items-center gap-3">
                  <div class="w-2 h-8 bg-white/80 rounded-full"></div>
                  <h1 class="text-3xl lg:text-4xl font-bold">
                    {{ greeting }}, {{ user?.displayName || user?.email?.split('@')[0] }}!
                  </h1>
                </div>
                
                <p class="text-lg text-white/90 leading-relaxed max-w-2xl">
                  Vous avez actuellement <span class="font-semibold bg-white/20 px-2 py-1 rounded-lg">{{ allNotifications.length }}</span> nouvelle<span v-if="allNotifications.length > 1">s</span> notification<span v-if="allNotifications.length > 1">s</span>, et vous travaillez sur <span class="font-semibold bg-white/20 px-2 py-1 rounded-lg">{{ allProjects.length }}</span> projet<span v-if="allProjects.length > 1">s</span> en cours.
                </p>
                
                <div class="flex items-center gap-4 pt-2">
                  <div class="flex items-center gap-2 bg-white/20 backdrop-blur-sm rounded-full px-4 py-2">
                    <div class="w-2 h-2 bg-green-300 rounded-full animate-pulse"></div>
                    <span class="text-sm font-medium">En ligne</span>
                  </div>
                  <div class="text-sm text-white/80">
                    Dernière connexion: {{ new Date().toLocaleDateString('fr-FR') }}
                  </div>
                </div>
              </div>
              
              <div class="flex justify-center lg:justify-end">
                <div class="relative">
                  <div class="absolute inset-0 bg-gradient-to-r from-white/20 to-white/10 rounded-full blur-xl"></div>
                  <UAvatar 
                    :src="user?.photoURL as string | undefined" 
                    :alt="user?.displayName || user?.email?.toUpperCase()"
                    class="relative w-24 h-24 lg:w-32 lg:h-32 ring-4 ring-white/30 shadow-2xl"
                  />
                  <div class="absolute -bottom-2 -right-2 w-8 h-8 bg-green-400 rounded-full border-4 border-white shadow-lg flex items-center justify-center">
                    <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                      <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                    </svg>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-xl rounded-2xl p-6 shadow-xl border border-white/20 dark:border-gray-700/50">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-gray-600 dark:text-gray-400">Projets Actifs</p>
                <p class="text-3xl font-bold text-gray-900 dark:text-white">{{ allProjects.length }}</p>
              </div>
              <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl flex items-center justify-center shadow-lg">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                </svg>
              </div>
            </div>
          </div>
          
          <div class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-xl rounded-2xl p-6 shadow-xl border border-white/20 dark:border-gray-700/50">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-gray-600 dark:text-gray-400">Notifications</p>
                <p class="text-3xl font-bold text-gray-900 dark:text-white">{{ allNotifications.length }}</p>
              </div>
              <div class="w-12 h-12 bg-gradient-to-br from-emerald-500 to-emerald-600 rounded-xl flex items-center justify-center shadow-lg">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5zM4 19h6v-2H4v2zM4 15h8v-2H4v2zM4 11h10V9H4v2z" />
                </svg>
              </div>
            </div>
          </div>
          
          <div class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-xl rounded-2xl p-6 shadow-xl border border-white/20 dark:border-gray-700/50">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-gray-600 dark:text-gray-400">Taux de Completion</p>
                <p class="text-3xl font-bold text-gray-900 dark:text-white">85%</p>
              </div>
              <div class="w-12 h-12 bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl flex items-center justify-center shadow-lg">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- Projects Section -->
        <div class="space-y-6">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                </svg>
              </div>
              <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Vos Projets</h2>
            </div>
          </div>

          <div v-if="allProjects.length" class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div 
              v-for="project in allProjects" 
              :key="project.id"
              class="group bg-white/70 dark:bg-gray-800/70 backdrop-blur-xl rounded-2xl p-6 shadow-xl border border-white/20 dark:border-gray-700/50 hover:shadow-2xl transition-all duration-300 hover:scale-[1.02] cursor-pointer"
              @click="navigateTo(`/projects/${project.id}`)"
            >
              <div class="space-y-4">
                <div class="flex items-start justify-between">
                  <div class="flex items-center gap-3">
                    <div class="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center shadow-lg">
                      <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                      </svg>
                    </div>
                    <div>
                      <h3 class="text-xl font-bold text-gray-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                        {{ project.name }}
                      </h3>
                      <p class="text-sm text-gray-600 dark:text-gray-400">
                        {{ project.description }}
                      </p>
                    </div>
                  </div>
                  <div class="opacity-0 group-hover:opacity-100 transition-opacity">
                    <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                  </div>
                </div>
                
                <div class="flex items-center justify-between text-xs text-gray-500 dark:text-gray-400">
                  <div class="flex items-center gap-4">
                    <div class="flex items-center gap-1">
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                      </svg>
                      <span>{{ formatDate(project.createdAt) }}</span>
                    </div>
                    <div class="flex items-center gap-1">
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                      </svg>
                      <span>{{ formatDate(project.updatedAt) }}</span>
                    </div>
                  </div>
                  <div class="px-3 py-1 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 rounded-full text-xs font-medium">
                    Actif
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div v-else class="text-center py-12">
            <div class="w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
              </svg>
            </div>
            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun projet pour le moment</h3>
            <p class="text-gray-600 dark:text-gray-400 mb-6">Commencez votre premier projet dès maintenant !</p>
            <button class="px-6 py-3 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-xl font-medium shadow-lg hover:shadow-xl transition-all duration-200 hover:scale-105">
              Créer un projet
            </button>
          </div>
        </div>

        <!-- Notifications Section -->
        <div class="space-y-6">
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-lg flex items-center justify-center">
              <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5zM4 19h6v-2H4v2zM4 15h8v-2H4v2zM4 11h10V9H4v2z" />
              </svg>
            </div>
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Notifications Récentes</h2>
          </div>

          <div v-if="allNotifications.length" class="space-y-4">
            <div 
              v-for="(notif, index) in allNotifications" 
              :key="index"
              class="group bg-white/70 dark:bg-gray-800/70 backdrop-blur-xl rounded-2xl p-6 shadow-xl border border-white/20 dark:border-gray-700/50 hover:shadow-2xl transition-all duration-300"
            >
              <div class="flex items-start gap-4">
                <div class="w-10 h-10 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-xl flex items-center justify-center shadow-lg flex-shrink-0">
                  <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                
                <div class="flex-1 min-w-0">
                  <p class="text-gray-900 dark:text-white font-medium">
                    {{ notif.message || 'Nouvelle notification reçue.' }}
                  </p>
                  <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                    {{ new Date(notif.timestamp || Date.now()).toLocaleString('fr-FR') }}
                  </p>
                </div>
                
                <button
                  class="px-4 py-2 bg-gradient-to-r from-emerald-500 to-teal-600 text-white rounded-xl font-medium shadow-lg hover:shadow-xl transition-all duration-200 hover:scale-105 opacity-0 group-hover:opacity-100"
                  @click="markAsRead(notif.id)"
                >
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </button>
              </div>
            </div>
          </div>

          <div v-else class="text-center py-12">
            <div class="w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5zM4 19h6v-2H4v2zM4 15h8v-2H4v2zM4 11h10V9H4v2z" />
              </svg>
            </div>
            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune notification</h3>
            <p class="text-gray-600 dark:text-gray-400">Vous êtes à jour ! Aucune nouvelle notification.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { Project } from '~/types';
import getGreeting from '~/utilities/greeting';

const allProjects = ref<Project[]>([]);
const allNotifications = ref<any[]>([]);

const { user } = useAuth();
const { initialize: initializeProjects, getProjects } = useProject();
const { initialize: initializeNotifications, fetchNotifications, markAsRead: markNotificationAsRead } = useNotifications();

const greeting = computed(() => getGreeting());

watch(user, async (newUser) => {
  if (newUser) {
    initializeNotifications(newUser.uid);
    await fetchNotifications((notification) => {
      allNotifications.value = notification;
    })

    initializeProjects(newUser.uid);
    allProjects.value = await getProjects();
  }
})

async function markAsRead(id: string) {
  await markNotificationAsRead(id);
  allNotifications.value = allNotifications.value.filter(n => n.id !== id);
}

// Helper functions
const formatDate = (date: Date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  }).format(date)
}
</script>

<style scoped>
/* Custom animations and effects */
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.animate-float {
  animation: float 6s ease-in-out infinite;
}

/* Glassmorphism effect */
.backdrop-blur-xl {
  backdrop-filter: blur(16px);
}

/* Smooth transitions */
* {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}
</style>