<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 dark:text-gray-300">
    <Header />

    <div class="pt-20">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Loading State -->
        <div v-if="!project" class="flex flex-col items-center justify-center py-16 animate-fade-in">
          <UIcon name="i-heroicons-arrow-path" class="w-12 h-12 text-emerald-500 animate-spin" />
          <p class="mt-4 text-gray-600 dark:text-gray-400">Chargement du projet...</p>
        </div>
        
        <!-- Project Content -->
        <div v-else class="animate-fade-in">
          <!-- Project Header -->
          <div class="mb-8">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
              <!-- Project Title & Info -->
              <div class="animate-fade-in-left">
                <div class="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400 mb-2">
                  <NuxtLink to="/inspections" class="hover:text-emerald-600 dark:hover:text-emerald-400 transition-colors">
                    Projets
                  </NuxtLink>
                  <UIcon name="i-heroicons-chevron-right" class="w-4 h-4" />
                  <span class="truncate">{{ project.name }}</span>
                </div>
                
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white flex items-center gap-3">
                  {{ project.name }}
                  <UBadge 
                    :color="getStatusColor(project)" 
                    variant="soft"
                    class="animate-pulse-slow"
                  >
                    {{ getStatusText(project) }}
                  </UBadge>
                </h1>
                
                <div class="flex items-center gap-4 mt-2 text-sm text-gray-600 dark:text-gray-400">
                  <div class="flex items-center">
                    <UIcon name="i-heroicons-calendar" class="w-4 h-4 mr-1" />
                    <span>Créé le {{ formatDate(project.createdAt) }}</span>
                  </div>
                  <div class="flex items-center">
                    <UIcon name="i-heroicons-chart-bar" class="w-4 h-4 mr-1" />
                    <span>{{ project.analysis.length }} analyses</span>
                  </div>
                </div>
              </div>
              
              <!-- Action Buttons -->
              <div class="flex items-center justify-center flex-wrap gap-3">
                <UButton
                  @click="showNewAnalysisModal = true"
                  color="success"
                  icon="i-heroicons-plus"
                  label="Nouvelle Analyse"
                  class="hover-scale cursor-pointer"
                />
                
                <UDropdownMenu :items="projectActions">
                  <UButton icon="i-lucide-menu" color="neutral" variant="outline" class="cursor-pointer" />
                </UDropdownMenu>
              </div>
            </div>
          </div>
          
          <!-- Project Content Tabs -->
          <UTabs :items="tabItems" class="animate-fade-in-up">
            <template #content="{ item }">
              <div v-if="item.value === 0" class="p-4">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                  <div v-for="(stat, index) in projectStats" :key="index" 
                    class="bg-white dark:bg-gray-800 rounded-xl p-6 shadow hover:shadow-md transition-shadow card-hover">
                    <div class="flex items-center">
                      <div :class="stat.bgColor" class="p-3 rounded-lg mr-4">
                        <UIcon :name="stat.icon" class="w-8 h-8" :class="stat.iconColor" />
                      </div>
                      <div>
                        <p class="text-sm text-gray-500 dark:text-gray-400">{{ stat.label }}</p>
                        <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ stat.value }}</p>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow p-6">
                  <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">Dernières analyses</h2>
                  <div class="space-y-4">
                    <div v-for="(analysis, index) in project.analysis.slice(0, 3)" :key="index" 
                      class="border border-gray-200 dark:border-gray-700 rounded-lg p-4 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors cursor-pointer"
                      @click="viewAnalysis(index)">
                      <div class="flex items-center justify-between">
                        <div>
                          <h3 class="font-medium text-gray-900 dark:text-white">Analyse #{{ index + 1 }}</h3>
                          <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                            {{ formatDate(analysis.createdAt) }} • {{ analysis.files.length }} fichiers
                          </p>
                        </div>
                        <div>
                          <UBadge 
                            :color="getAnalysisStatusColor(analysis)" 
                            variant="soft"
                          >
                            {{ getAnalysisStatusText(analysis) }}
                          </UBadge>
                        </div>
                      </div>
                      <div class="mt-3 flex gap-2 overflow-x-auto pb-2 dark:hover:bg-gray-800">
                        <div v-for="(file, fileIndex) in analysis.files.slice(0, 8)" :key="fileIndex" 
                          class="flex-shrink-0 w-16 h-16 rounded-md overflow-hidden bg-gray-100 dark:hover:bg-gray-800 dark:bg-gray-700">
                        
                          <img v-if="!isVideo(file as string)" :src="file as string" class="w-full h-full object-cover" />
                          <div v-else class="w-full h-full flex items-center justify-center">
                            <UIcon name="i-heroicons-film" class="w-6 h-6 text-gray-400" />
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <div v-else-if="item.value === 1" class="p-4">
                <div class="mb-6 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                  <UInput 
                    v-model="analysisSearchQuery" 
                    placeholder="Rechercher des analyses..." 
                    icon="i-heroicons-magnifying-glass"
                    class="max-w-md"
                  />
                  
                  <USelect 
                    v-model="analysisSortBy" 
                    :options="sortOptions" 
                    class="min-w-[200px]"
                  />
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  <div v-for="(analysis, index) in filteredAnalyses" :key="index"
                    class="border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden bg-white dark:bg-gray-800 shadow hover:shadow-md transition-shadow cursor-pointer card-hover"
                    @click="viewAnalysis(index)">
                    <div class="relative aspect-video bg-gray-100 dark:bg-gray-700">
                      <!--<img 
                        v-if="!isVideo(analysis.files[0])" 
                        :src="analysis.files[0]" 
                        class="w-full h-full object-cover"
                      />
                      <div v-else class="w-full h-full flex items-center justify-center">
                        <UIcon name="i-heroicons-film" class="w-12 h-12 text-gray-400" />
                      </div>-->
                      <div class="absolute top-3 right-3">
                        <UBadge 
                          :color="getAnalysisStatusColor(analysis)" 
                          variant="soft"
                        >
                          {{ getAnalysisStatusText(analysis) }}
                        </UBadge>
                      </div>
                    </div>
                    <div class="p-4 dark:hover:bg-gray-800">
                      <h3 class="font-bold text-lg text-gray-900 dark:text-white mb-1">Analyse</h3>
                      <p class="text-sm text-gray-500 dark:text-gray-400 mb-3">
                        {{ formatDate(analysis.createdAt) }} • {{ analysis.files.length }} fichiers
                      </p>
                      <div class="flex justify-between items-center">
                        <div>
                          <p class="text-xs text-gray-500 dark:text-gray-400">Défauts détectés</p>
                          <p class="font-semibold text-gray-900 dark:text-white">
                            {{ analysis.result?.defects || 0 }}
                          </p>
                        </div>
                        <UButton 
                          icon="i-heroicons-eye" 
                          color="neutral" 
                          variant="ghost"
                          @click.stop="viewAnalysis(index)"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <div v-else class="p-4">
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow p-6">
                  <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-6">Rapports du projet</h2>
                  <div class="space-y-4">
                    <div class="border border-gray-200 dark:border-gray-700 rounded-lg p-4 flex justify-between items-center">
                      <div>
                        <h3 class="font-medium text-gray-900 dark:text-white">Rapport complet</h3>
                        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                          Toutes les analyses combinées dans un seul document
                        </p>
                      </div>
                      <UButton 
                        icon="i-heroicons-arrow-down-tray" 
                        color="success"
                        label="Télécharger"
                      />
                    </div>
                    
                    <div v-for="(analysis, index) in project.analysis" :key="index"
                      class="border border-gray-200 dark:border-gray-700 dark:hover:bg-gray-800 rounded-lg p-4 flex justify-between items-center">
                      <div>
                        <h3 class="font-medium text-gray-900 dark:text-white">Analyse #{{ index + 1 }}</h3>
                        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                          {{ formatDate(analysis.createdAt) }} • {{ analysis.files.length }} fichiers
                        </p>
                      </div>
                      <UButton 
                        icon="i-heroicons-arrow-down-tray" 
                        color="neutral"
                        variant="outline"
                        label="Télécharger"
                        @click="downloadAnalysisReport(analysis)"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </template>
          </UTabs>
        </div>
      </div>
    </div>
    
    <!-- Analysis Detail Modal -->
    <UModal 
      v-model:open="showAnalysisModal" 
      class="sm:max-w-5xl"
      :key="showAnalysisModal ? 'open': 'closed'"
    >   
      <template #content>
        <UCarousel
          v-slot="{ item }"
          loop
          dots
          arrows
          :items="selectedAnalysis?.files"
          :ui="{ item: 'basis-1/3' }"
        >
          <div class="flex items-center justify-center">
            <img v-if="!isVideo(item as string)" class="rounded-lg" :src="item as string">
            <video v-else class="rounded-lg" :src="item as string" alt=""/>
          </div>
        </UCarousel>          
      </template>
    </UModal>
    
    <!-- New Analysis Modal -->
    <UModal 
      v-model:open="showNewAnalysisModal" 
      title="Nouvelle Analyse"
      :overlay="true"
      :key="showNewAnalysisModal ? 'open': 'closed'"
    >
      <template #close @click="showNewAnalysisModal = false">
      </template>
      <template #body>
        <div class="space-y-4">
            <!-- File Upload -->
            <UFormField name="files" required>
                <div class="border-2 border-dashed border-gray-300 dark:border-gray-700 rounded-lg p-6 text-center">
                <UIcon name="i-heroicons-cloud-arrow-up" class="w-12 h-12 mx-auto text-gray-400 dark:text-gray-600 mb-4" />
                
                <h4 class="text-base font-medium text-gray-900 dark:text-white mb-2">
                    Déposez vos fichiers ici
                </h4>
                
                <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">
                    Formats supportés: JPG, PNG, MP4, MOV (max 50MB)
                </p>
                
                <UInput 
                    type="file" 
                    multiple 
                    accept="image/*,video/*"
                    @change="handleFileUpload"
                    class="cursor-pointer gap-4 text-gray-600 text-wrap whitespace-nowrap"
                    ref="fileInput"
                    placeholder="Sélectionner des fichiers"
                />
              </div>
            </UFormField>
            
            <!-- Selected Files Preview -->
            <div v-if="newAnalysisFiles.length > 0" class="space-y-2">
                <h4 class="text-sm font-medium text-gray-900 dark:text-white">
                Fichiers sélectionnés ({{ newAnalysisFiles.length }})
                </h4>
                
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-2">
                <div 
                    v-for="(file, index) in newAnalysisFiles" 
                    :key="index"
                    class="relative aspect-square bg-gray-100 dark:bg-gray-800 rounded-md overflow-hidden group"
                >
                    <!-- File Preview -->
                    <img 
                      v-if="file.type.startsWith('image')" 
                      :src="file.preview" 
                      class="w-full h-full object-cover"
                    />
                    <div 
                      v-else 
                      class="w-full h-full flex items-center justify-center bg-gray-200 dark:bg-gray-700"
                    >
                      <UIcon name="i-heroicons-film" class="w-8 h-8 text-gray-500" />
                    </div>
                    
                    <!-- Remove Button -->
                    <button
                    @click="removeFile(index)"
                    class="absolute top-1 right-1 bg-black/50 hover:bg-black/70 text-white rounded-full p-1 opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                    aria-label="Supprimer"
                    >
                      <UIcon name="i-heroicons-x-mark" class="w-3 h-3" />
                    </button>
                </div>
                </div>
            </div>
        </div>
      </template>
      <template #footer>
        <div class="flex justify-end space-x-3">
          <UButton
            @click="showNewAnalysisModal = false"
            color="neutral"
            variant="ghost"
            label="Annuler"
            class="cursor-pointer"
          />
          <UButton
            @click="createAnalysis"
            color="success"
            :loading="creatingAnalysis"
            :disabled="newAnalysisFiles.length === 0"
            icon="i-heroicons-rocket-launch"
            label="Lancer l'analyse"
            class="cursor-pointer"
          />
        </div>
      </template>
    </UModal>
  </div>
</template>

<script lang="ts" setup>
import { useRoute } from 'vue-router'
import { ref, computed, watch } from 'vue'
import type { Project, Analysis } from '~/types'

// Route
const route = useRoute()
const projectId = computed(() => route.params.id as string)

// State
const { user } = useAuth()
const { initialize, getProjectById, addAnalysis, getAnalysisForProject } = useProject()
const showAnalysisModal = ref(false)
const showNewAnalysisModal = ref(false)
const selectedAnalysisIndex = ref(0)
const currentSlide = ref(0)
const analysisSearchQuery = ref('')
const analysisSortBy = ref('newest')
const creatingAnalysis = ref(false)
const newAnalysisFiles = ref<{
  file: File,
  preview: string,
  type: string
}[]>([]);
const newAnalysisNotes = ref('')
const project = ref<Project | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)

// Initialize project data
watch(user, async (newUser) => {
  if (newUser) {
    initialize(newUser.uid);
    project.value = await getProjectById(projectId.value);
    if (project.value) {
      project.value.analysis = await getAnalysisForProject(projectId.value);
    }
  }
}, { immediate: true })

// Computed
const selectedAnalysis = computed(() => {
  if (!project.value || selectedAnalysisIndex.value < 0) return null
  return project.value.analysis[selectedAnalysisIndex.value]
})

const sortedAnalyses = computed(() => {
  if (!project.value) return []
  return [...project.value.analysis].sort((a, b) => 
    new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
  )
})

const filteredAnalyses = computed(() => {
  if (!project.value) return []
  
  let analyses = [...project.value.analysis]
  
  // Apply search filter if needed
  if (analysisSearchQuery.value) {
    analyses = analyses.filter(a => 
      a.files.some(f => f.toLowerCase().includes(analysisSearchQuery.value.toLowerCase()))
    )
  }
  
  // Apply sorting
  switch (analysisSortBy.value) {
    case 'newest':
      analyses.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
      break
    case 'oldest':
      analyses.sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime())
      break
    case 'most-files':
      analyses.sort((a, b) => b.files.length - a.files.length)
      break
    case 'severity':
      analyses.sort((a, b) => {
        const severityMap: Record<string, number> = { high: 3, medium: 2, low: 1 }
        return (severityMap[b.result?.severity || 'low'] || 0) - (severityMap[a.result?.severity || 'low'] || 0)
      })
      break
  }
  
  return analyses
})

const projectStats = computed(() => {
  if (!project.value) return []
  
  const totalFiles = project.value.analysis.reduce((sum, a) => sum + a.files.length, 0)
  const totalDefects = project.value.analysis.reduce((sum, a) => sum + (a.result?.defects || 0), 0)
  
  return [
    {
      label: 'Analyses',
      value: project.value.analysis.length,
      icon: 'i-heroicons-document-magnifying-glass',
      bgColor: 'bg-emerald-100 dark:bg-emerald-900',
      iconColor: 'text-emerald-600 dark:text-emerald-400'
    },
    {
      label: 'Fichiers',
      value: totalFiles,
      icon: 'i-heroicons-photo',
      bgColor: 'bg-blue-100 dark:bg-blue-900',
      iconColor: 'text-blue-600 dark:text-blue-400'
    },
    {
      label: 'Défauts détectés',
      value: totalDefects,
      icon: 'i-heroicons-shield-exclamation',
      bgColor: 'bg-orange-100 dark:bg-orange-900',
      iconColor: 'text-orange-600 dark:text-orange-400'
    },
    {
      label: 'Dernière analyse',
      value: project.value.analysis.length ? formatRelativeDate(project.value.analysis[0].createdAt) : '-',
      icon: 'i-heroicons-calendar',
      bgColor: 'bg-purple-100 dark:bg-purple-900',
      iconColor: 'text-purple-600 dark:text-purple-400'
    }
  ]
})

// Tab items
const tabItems = [
  {
    label: 'Aperçu',
    icon: 'i-heroicons-home',
    value: 0
  },
  {
    label: 'Analyses',
    icon: 'i-heroicons-document-magnifying-glass',
    value: 1,
    badge: computed(() => project.value?.analysis.length || 0)
  },
  {
    label: 'Rapports',
    icon: 'i-heroicons-document-chart-bar',
    value: 2
  }
]

// Project actions dropdown
const projectActions = [
  [
    {
      label: 'Modifier le projet',
      icon: 'i-heroicons-pencil',
      click: () => console.log('Edit project')
    },
    {
      label: 'Dupliquer',
      icon: 'i-heroicons-document-duplicate',
      click: () => console.log('Duplicate project')
    }
  ],
  [
    {
      label: 'Exporter les données',
      icon: 'i-heroicons-arrow-down-tray',
      click: () => console.log('Export project data')
    },
    {
      label: 'Partager',
      icon: 'i-heroicons-share',
      click: () => console.log('Share project')
    }
  ],
  [
    {
      label: 'Supprimer le projet',
      icon: 'i-heroicons-trash',
      click: () => console.log('Delete project')
    }
  ]
]

// Sort options
const sortOptions = [
  { label: 'Plus récent', value: 'newest' },
  { label: 'Plus ancien', value: 'oldest' },
  { label: 'Plus de fichiers', value: 'most-files' },
  { label: 'Sévérité', value: 'severity' }
]

// Methods
const viewAnalysis = (index: number) => {
  selectedAnalysisIndex.value = index
  currentSlide.value = 0
  showAnalysisModal.value = true
}

const downloadAnalysisReport = (analysis: Analysis) => {
  // Mock download functionality
  console.log('Downloading report for analysis:', analysis)
  // In a real app, this would trigger a download of a PDF or other report format
}

const nextSlide = () => {
  if (!selectedAnalysis.value) return
  currentSlide.value = (currentSlide.value + 1) % selectedAnalysis.value.files.length
}

const prevSlide = () => {
  if (!selectedAnalysis.value) return
  currentSlide.value = (currentSlide.value - 1 + selectedAnalysis.value.files.length) % selectedAnalysis.value.files.length
}

const handleFileUpload = (e: Event) => {
  const input = e.target as HTMLInputElement
  if (!input.files || input.files.length === 0) return
  
  Array.from(input.files).forEach(file => {
    if (!file.type.match('image.*|video.*')) return
    
    newAnalysisFiles.value.push({
      file,
      preview: URL.createObjectURL(file),
      type: file.type.split('/')[0]
    })
  })
}

const removeFile = (index: number) => {
  URL.revokeObjectURL(newAnalysisFiles.value[index].preview)
  newAnalysisFiles.value.splice(index, 1)
}

const createAnalysis = async () => {
  if (newAnalysisFiles.value.length === 0 || !project.value) return
  
  creatingAnalysis.value = true
  
  try {
    const uploadPromises = newAnalysisFiles.value.map((analysisFile) => {
      const formData = new FormData();
      formData.append('file', analysisFile.file);

      return fetch('/api/upload', {
        method: 'POST',
        body: formData,
      })
        .then(async (res) => {
          if (!res.ok) throw new Error(await res.text());
          const data = await res.json();
          return data.fileUrl;
        })
        .catch((err) => {
          console.log(`Erreur : ${err.message}`);
          return null; // skip failed upload
        });
    });

    const files = (await Promise.all(uploadPromises)).filter((f) => f !== null) as string[];

    // Create new analysis
    const newAnalysis: Analysis = {
      files,
      result: {},
      createdAt: new Date(),
      updatedAt: new Date()
    }
    
    console.log(newAnalysis);
    
    await addAnalysis(project.value.id, newAnalysis);

    await fetch('/api/jobs.create', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        type: 'Analysis',
        data: {
          files,
          result: {},
          createdAt: new Date(),
          updatedAt: new Date()
        },
        user: user.value?.uid
      })
    });

    // Add to project
    project.value.analysis.unshift(newAnalysis)
    
    // Reset form
    newAnalysisFiles.value.forEach(file => URL.revokeObjectURL(file.preview))
    newAnalysisFiles.value = []
    newAnalysisNotes.value = ''
    
    // Close modal
    showNewAnalysisModal.value = false
  } catch (e) {
    console.error('Error creating analysis:', e)
  } finally {
    creatingAnalysis.value = false
  }
}

// Helper functions
const formatDate = (date: Date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  }).format(date)
}

const formatRelativeDate = (date: Date) => {
  const daysDiff = Math.floor((Date.now() - new Date(date).getTime()) / (1000 * 60 * 60 * 24))
  
  if (daysDiff === 0) return 'Aujourd\'hui'
  if (daysDiff === 1) return 'Hier'
  if (daysDiff < 7) return `Il y a ${daysDiff} jours`
  if (daysDiff < 30) return `Il y a ${Math.floor(daysDiff / 7)} semaines`
  return formatDate(date)
}

const getStatusColor = (project: Project) => {
  if (project.analysis.length === 0) return 'neutral'
  if (project.analysis.length < 3) return 'warning'
  return 'success'
}

const getStatusText = (project: Project) => {
  if (project.analysis.length === 0) return 'Nouveau'
  if (project.analysis.length < 3) return 'En cours'
  return 'Actif'
}

const getAnalysisStatusColor = (analysis: Analysis) => {
  const severity = analysis.result?.severity || 'low'
  if (severity === 'high') return 'error'
  if (severity === 'medium') return 'warning'
  return 'success'
}

const getAnalysisStatusText = (analysis: Analysis) => {
  const severity = analysis.result?.severity || 'low'
  if (severity === 'high') return 'Critique'
  if (severity === 'medium') return 'Attention'
  return 'Normal'
}

const getSeverityColor = (severity: string) => {
  if (severity === 'high') return 'error'
  if (severity === 'medium') return 'warning'
  return 'success'
}

const getSeverityText = (severity: string) => {
  if (severity === 'high') return 'Élevée'
  if (severity === 'medium') return 'Moyenne'
  return 'Faible'
}

const getDefectSeverityColor = (defects: number) => {
  if (defects >= 5) return 'error'
  if (defects >= 2) return 'warning'
  return 'success'
}

const getStructureHealthPercent = (result: Record<string, any>) => {
  return result.health || 100
}

const getStructureHealthColor = (result: Record<string, any>) => {
  const health = result.health || 100
  if (health < 60) return 'bg-gradient-to-r from-red-500 to-red-600'
  if (health < 80) return 'bg-gradient-to-r from-yellow-500 to-yellow-600'
  return 'bg-gradient-to-r from-emerald-500 to-teal-600'
}

const isVideo = (url: string) => {
  return url.match(/\.(mp4|mov|webm|avi|wmv|flv|mkv)($|\?)/i) || 
         url.includes('vimeo.com') || 
         url.includes('youtube.com') ||
         url.includes('youtu.be')
}
</script>

<style scoped>
.animate-glow {
  animation: glow 2s ease-in-out infinite alternate;
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 5px rgba(16, 185, 129, 0.5); }
  50% { box-shadow: 0 0 20px rgba(16, 185, 129, 0.8), 0 0 30px rgba(16, 185, 129, 0.6); }
}

.animate-pulse-slow {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
</style>