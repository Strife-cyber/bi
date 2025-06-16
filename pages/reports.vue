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

                      <!-- Project Report Details -->
                      <div v-if="analysis.result" class="mb-4">
                        <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">
                          Détails des Détections
                        </h4>
                        
                        <div class="overflow-x-auto rounded-lg border border-gray-200 dark:border-gray-700">
                          <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                            <thead class="bg-gray-50 dark:bg-gray-800">
                              <tr>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Fichier</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Type</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Détections</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Résultats</th>
                              </tr>
                            </thead>
                            <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                              <tr v-for="(result, index) in analysis.result" :key="index">
                                <!-- File Preview -->
                                <td class="px-4 py-3 whitespace-nowrap">
                                  <div class="relative group">
                                    <!-- @vue-expect-error -->
                                    <img 
                                      v-if="result.type === 'image'"
                                      :src="analysis.files[index]"
                                      class="w-20 h-20 object-cover rounded-lg border border-gray-200 dark:border-gray-700 shadow-sm"
                                    />
                                    <div 
                                      v-else
                                      class="w-20 h-20 bg-gray-100 dark:bg-gray-700 rounded-lg border border-gray-200 dark:border-gray-700 flex items-center justify-center"
                                    >
                                      <UIcon name="i-heroicons-video-camera" class="w-8 h-8 text-gray-400 dark:text-gray-500" />
                                    </div>
                                    <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity rounded-lg">
                                      <UIcon name="i-heroicons-magnifying-glass-plus" class="w-6 h-6 text-white" />
                                    </div>
                                  </div>
                                </td>
                                
                                <!-- Type -->
                                <td class="px-4 py-3 whitespace-nowrap">
                                  <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full" 
                                        :class="result.type === 'image' 
                                          ? 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-100' 
                                          : 'bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-100'">
                                    {{ result.type === 'image' ? 'Image' : 'Vidéo' }}
                                  </span>
                                </td>
                                
                                <!-- Detections -->
                                <td class="px-4 py-3">
                                  <div class="flex items-center">
                                    <div class="mr-2">
                                      <span class="text-sm font-medium text-gray-900 dark:text-white">
                                        {{ result.valid_detections }}
                                      </span>
                                      <span class="text-xs text-gray-500 dark:text-gray-400">/</span>
                                      <span class="text-xs text-gray-500 dark:text-gray-400">
                                        {{ result.type === 'video' ? result.frames_analyzed + ' images' : '1 image' }}
                                      </span>
                                    </div>
                                    <div class="relative pt-1">
                                      <div class="overflow-hidden h-2 text-xs flex rounded bg-emerald-200 dark:bg-emerald-900 w-20">
                                        <div :style="'width:' + (result.valid_detections/(result.type === 'video' ? result.frames_analyzed : 1)*100 + '%')" 
                                            class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-emerald-500 dark:bg-emerald-600"></div>
                                      </div>
                                    </div>
                                  </div>
                                </td>
                                
                                <!-- Results -->
                                <td class="px-4 py-3">
                                  <div v-if="Object.keys(result.class_distribution).length > 0">
                                    <div v-for="(count, className) in result.class_distribution" :key="className" class="mb-1 last:mb-0">
                                      <div class="flex items-center">
                                        <!-- @vue-expect-error -->
                                        <span class="inline-block w-3 h-3 rounded-full mr-2" 
                                              :class="className === '0' ? 'bg-red-500' : 'bg-yellow-500'"></span>
                                        <span class="text-sm font-medium text-gray-900 dark:text-white mr-2">
                                          {{ 
                                            // @ts-ignore
                                            getClassName(className) 
                                          }}:
                                        </span>
                                        <span class="text-sm text-gray-600 dark:text-gray-400">
                                          {{ count }} détection{{ count > 1 ? 's' : '' }}
                                        </span>
                                      </div>
                                    </div>
                                  </div>
                                  <div v-else class="text-sm text-gray-500 dark:text-gray-400 italic">
                                    Aucune détection
                                  </div>
                                </td>
                              </tr>
                            </tbody>
                          </table>
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
import generateReport from '~/utilities/download-report';

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

// Add to script setup
const getClassName = (classId: string) => {
  const classNames: Record<string, string> = {
    '0': 'Fissure',
    '1': 'Corrosion',
    '2': 'Déformation',
    '3': 'Dommage'
  }
  return classNames[classId] || `Classe ${classId}`
}

const getOverallSeverity = (project: Project) => {
  const severities = project.analysis.map(a => a.result.severity)
  if (severities.includes('high')) return 'high'
  if (severities.includes('medium')) return 'medium'
  if (severities.includes('low')) return 'low'
  return 'none'
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

const downloadReport = async (projectId: string, analysisIndex: number) => {
  console.log(`Downloading report for project ${projectId}, analysis ${analysisIndex}`)
  await generateReport(projectId, analysisIndex, projects.value);
}
</script>
