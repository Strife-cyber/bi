<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <Header />
    
    <div class="pt-24">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Page Header -->
        <div class="mb-8 animate-fade-in-down">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h1 class="text-3xl font-bold text-gray-900 dark:text-white">
                Résultats d'Analyses
              </h1>
              <p class="mt-2 text-gray-600 dark:text-gray-400">
                Explorez les résultats détaillés de vos inspections de bâtiments
              </p>
            </div>
            
            <div class="mt-4 sm:mt-0 flex space-x-3">
              <!-- Search -->
              <div class="relative">
                <input 
                  v-model="searchQuery"
                  placeholder="Rechercher un projet..." 
                  class="rounded-md w-64 border-1 border-green-500 p-2 dark:text-white"
                />
              </div>
            </div>
          </div>
        </div>

        <!-- Projects Tree Structure -->
        <div class="space-y-6">
          <div 
            v-for="(project, projectIndex) in filteredProjects" 
            :key="project.id"
            class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden animate-fade-in-up"
            :style="`animation-delay: ${projectIndex * 150}ms`"
          >
            <!-- Project Header -->
            <div 
              class="p-6 border-b border-gray-200 dark:border-gray-700 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-700/80 transition-colors duration-200"
              @click="toggleProject(project.id)"
            >
              <div class="flex items-center justify-between">
                <div class="flex items-center space-x-4">
                  <!-- Expand/Collapse Icon -->
                  <div class="flex-shrink-0">
                    <UIcon 
                      :name="expandedProjects.includes(project.id) ? 'i-heroicons-chevron-down' : 'i-heroicons-chevron-right'" 
                      class="w-5 h-5 text-gray-500 dark:text-gray-400 transition-transform duration-200"
                    />
                  </div>
                  
                  <!-- Project Icon -->
                  <div class="w-12 h-12 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-lg flex items-center justify-center animate-glow">
                    <UIcon name="i-heroicons-building-office-2" class="w-6 h-6 text-white animate-float" />
                  </div>
                  
                  <!-- Project Info -->
                  <div>
                    <h2 class="text-xl font-semibold text-gray-900 dark:text-white">
                      {{ project.name }}
                    </h2>
                    <div class="flex items-center space-x-4 mt-1">
                      <span class="text-sm text-gray-500 dark:text-gray-400">
                        {{ formatDate(project.createdAt) }}
                      </span>
                      <span class="text-sm text-gray-500 dark:text-gray-400">
                        {{ project.analysis.length }} analyse{{ project.analysis.length > 1 ? 's' : '' }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Project Analyses (Collapsible) -->
            <div 
              v-if="expandedProjects.includes(project.id)"
              class="border-l-4 border-emerald-500 ml-6"
            >
              <div class="space-y-4 p-6 pl-8">
                <div 
                  v-for="(analysis, analysisIndex) in project.analysis" 
                  :key="analysisIndex"
                  class="relative animate-fade-in-up"
                  :style="`animation-delay: ${(projectIndex * 150) + (analysisIndex * 100)}ms`"
                >
                  <!-- Analysis Node -->
                  <div class="flex items-start space-x-4">
                    <!-- Tree Line -->
                    <div class="flex flex-col items-center">
                      <div class="w-4 h-4 bg-emerald-500 rounded-full border-2 border-white dark:border-gray-800 shadow-lg animate-pulse-slow"></div>
                      <div 
                        v-if="analysisIndex < project.analysis.length - 1"
                        class="w-0.5 h-16 bg-emerald-300 dark:bg-emerald-700 mt-2"
                      ></div>
                    </div>
                    
                    <!-- Analysis Content -->
                    <div class="flex-1 bg-gray-50 dark:bg-gray-800 rounded-lg p-6 hover:shadow-md transition-shadow duration-200">
                      <!-- Analysis Header -->
                      <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center space-x-3">
                          <UIcon name="i-heroicons-magnifying-glass" class="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
                          <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
                            Analyse #{{ analysisIndex + 1 }}
                          </h3>
                          <span class="text-sm text-gray-500 dark:text-gray-400">
                            {{ formatDate(analysis.createdAt) }}
                          </span>
                        </div>
                      </div>

                      <!-- Files Analyzed -->
                      <div class="mb-4">
                        <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                          Fichiers analysés ({{ analysis.files.length }})
                        </h4>
                        <div class="flex flex-wrap gap-2">
                          <div 
                            v-for="file in analysis.files" 
                            :key="file as string"
                            class="flex items-center flex-wrap space-x-2 bg-white dark:bg-gray-800 px-3 py-1 border border-gray-200 dark:border-gray-700 hover-lift"
                          >
                            <img class="w-8 h-8" :src="file as string" alt="">
                          </div>
                        </div>
                      </div>

                      <!-- Action Buttons -->
                      <div class="flex items-center justify-end space-x-2 mt-4 pt-4 border-t border-gray-200 dark:border-gray-700 dark:text-white">
                        <UButton
                          @click="downloadReport(project.id, analysisIndex)"
                          variant="soft"
                          size="sm"
                          class="hover-scale cursor-pointer"
                        >
                          <UIcon name="i-heroicons-arrow-down-tray" class="w-4 h-4 mr-2" />
                          Télécharger
                        </UButton>
                        
                        <UButton
                          @click="shareAnalysis(project.id, analysisIndex)"
                          variant="soft"
                          size="sm"
                          class="hover-scale cursor-pointer"
                        >
                          <UIcon name="i-heroicons-share" class="w-4 h-4 mr-2" />
                          Partager
                        </UButton>
                        
                        <UButton
                          @click="viewDetails(project.id, analysisIndex)"
                          variant="soft"
                          size="sm"
                          class="hover-scale cursor-pointer"
                        >
                          <UIcon name="i-heroicons-eye" class="w-4 h-4 mr-2" />
                          Détails
                        </UButton>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-if="filteredProjects.length === 0" class="text-center py-16 animate-fade-in-up">
          <div class="mx-auto w-24 h-24 bg-gradient-to-br from-gray-100 to-gray-200 dark:from-gray-800 dark:to-gray-700 rounded-full flex items-center justify-center mb-6 animate-morphing">
            <UIcon name="i-heroicons-magnifying-glass" class="w-12 h-12 text-gray-400 animate-float" />
          </div>
          
          <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-2">
            Aucun résultat trouvé
          </h3>
          
          <p class="text-gray-500 dark:text-gray-400 mb-8 max-w-md mx-auto">
            Aucun projet ne correspond à vos critères de recherche. 
            Essayez de modifier vos filtres ou créez un nouveau projet.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Project } from '~/types'
import { ref, computed, onMounted } from 'vue'

// Page metadata
definePageMeta({
  title: 'Résultats d\'Analyses - Bâtiment Intelligent',
  description: 'Consultez les résultats détaillés de vos analyses de bâtiments'
});

// State
const searchQuery = ref('');
const selectedFilter = ref('all');
const projects = ref<Project[]>([]);
const expandedProjects = ref<string[]>([]);
const expandedAnalyses = ref<string[]>([]);

const { user } = useAuth();
const { initialize, getProjects, getAnalysisForProject } = useProject();

watch(user, async (newUser) => {
  if (newUser) {
    initialize(newUser.uid);
    projects.value = await getProjects();

    const analysisPromises = projects.value.map(async (project) => {
      project.analysis = await getAnalysisForProject(project.id);
      return project;
    });

    projects.value = await Promise.all(analysisPromises);
  }
});

// Computed properties
const filteredProjects = computed(() => {
  let filtered = projects.value

  // Apply search filter
  if (searchQuery.value) {
    filtered = filtered.filter(p => 
      p.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }

  // Apply severity filter
  if (selectedFilter.value !== 'all') {
    filtered = filtered.filter(p => {
      const overallSeverity = getOverallSeverity(p)
      switch (selectedFilter.value) {
        case 'critical':
          return overallSeverity === 'high'
        case 'medium':
          return overallSeverity === 'medium'
        case 'low':
          return overallSeverity === 'low'
        case 'none':
          return overallSeverity === 'none'
        default:
          return true
      }
    })
  }

  return filtered
})

// Methods
const toggleProject = (projectId: string) => {
  const index = expandedProjects.value.indexOf(projectId)
  if (index > -1) {
    expandedProjects.value.splice(index, 1)
  } else {
    expandedProjects.value.push(projectId)
  }
}

const toggleAnalysis = (projectId: string, analysisIndex: number) => {
  const key = `${projectId}-${analysisIndex}`
  const index = expandedAnalyses.value.indexOf(key)
  if (index > -1) {
    expandedAnalyses.value.splice(index, 1)
  } else {
    expandedAnalyses.value.push(key)
  }
}

const formatDate = (date: Date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  }).format(date)
}

const getOverallSeverity = (project: Project) => {
  const severities = project.analysis.map(a => a.result.severity)
  if (severities.includes('high')) return 'high'
  if (severities.includes('medium')) return 'medium'
  if (severities.includes('low')) return 'low'
  return 'none'
}

const getDefectIcon = (type: string) => {
  switch (type.toLowerCase()) {
    case 'fissure':
    case 'fissure structurelle':
    case 'fissure de retrait':
      return 'i-heroicons-bolt'
    case 'humidité':
    case 'infiltration d\'eau':
      return 'i-heroicons-cloud-rain'
    case 'corrosion':
      return 'i-heroicons-exclamation-triangle'
    case 'décollement d\'enduit':
      return 'i-heroicons-square-3-stack-3d'
    case 'tuiles cassées':
      return 'i-heroicons-home'
    case 'gouttière obstruée':
      return 'i-heroicons-funnel'
    default:
      return 'i-heroicons-exclamation-circle'
  }
}

const getDefectIconBg = (type: string) => {
  switch (type.toLowerCase()) {
    case 'fissure':
    case 'fissure structurelle':
    case 'fissure de retrait':
      return 'bg-red-100 dark:bg-red-900'
    case 'humidité':
    case 'infiltration d\'eau':
      return 'bg-blue-100 dark:bg-blue-900'
    case 'corrosion':
      return 'bg-orange-100 dark:bg-orange-900'
    case 'décollement d\'enduit':
      return 'bg-purple-100 dark:bg-purple-900'
    case 'tuiles cassées':
      return 'bg-yellow-100 dark:bg-yellow-900'
    case 'gouttière obstruée':
      return 'bg-gray-100 dark:bg-gray-800'
    default:
      return 'bg-gray-100 dark:bg-gray-800'
  }
}

const getDefectIconColor = (type: string) => {
  switch (type.toLowerCase()) {
    case 'fissure':
    case 'fissure structurelle':
    case 'fissure de retrait':
      return 'text-red-600 dark:text-red-400'
    case 'humidité':
    case 'infiltration d\'eau':
      return 'text-blue-600 dark:text-blue-400'
    case 'corrosion':
      return 'text-orange-600 dark:text-orange-400'
    case 'décollement d\'enduit':
      return 'text-purple-600 dark:text-purple-400'
    case 'tuiles cassées':
      return 'text-yellow-600 dark:text-yellow-400'
    case 'gouttière obstruée':
      return 'text-gray-600 dark:text-gray-400'
    default:
      return 'text-gray-600 dark:text-gray-400'
  }
}

const downloadReport = (projectId: string, analysisIndex: number) => {
  console.log(`Downloading report for project ${projectId}, analysis ${analysisIndex}`)
  // TODO: Implement download functionality
}

const shareAnalysis = (projectId: string, analysisIndex: number) => {
  console.log(`Sharing analysis for project ${projectId}, analysis ${analysisIndex}`)
  // TODO: Implement share functionality
}

const viewDetails = (projectId: string, analysisIndex: number) => {
  console.log(`Viewing details for project ${projectId}, analysis ${analysisIndex}`)
  // TODO: Navigate to detailed view
}

// Lifecycle
onMounted(() => {
  // Auto-expand first project for demo
  if (projects.value.length > 0) {
    expandedProjects.value.push(projects.value[0].id)
  }
})
</script>
