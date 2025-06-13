<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 dark:text-gray-300">
    <Header/>

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
                  class="hover-scale p-2 border-1 border-green-400 cursor-pointer"
                >
                  <UIcon name="i-heroicons-plus" class="w-4 h-4 mr-2" />
                  Nouvelle Analyse
                </UButton>
                
                <UDropdownMenu
                  :items="projectActions"
                >
                  <UButton  label="Open" icon="i-lucide-menu" color="neutral" variant="outline"></UButton>
                </UDropdownMenu>
              </div>
            </div>
          </div>
          
          <!-- Project Content Tabs -->
          <UTabs :items="tabItems" :default-value="0" class="animate-fade-in-up">
            <!-- TODO Place project content here -->
          </UTabs>
        </div>
      </div>
    </div>
    
    <!-- Analysis Detail Modal -->
    <UModal v-model:open="showAnalysisModal" class="max-w-5xl">
      <UCard>
        <template #header>
          <div class="flex items-center justify-between">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
              Analyse #{{ selectedAnalysisIndex + 1 }}
            </h3>
            <UButton
              @click="showAnalysisModal = false"
              color="neutral"
              variant="ghost"
              size="sm"
            >
              <UIcon name="i-heroicons-x-mark" class="w-4 h-4" />
            </UButton>
          </div>
        </template>
        
        <div v-if="selectedAnalysis" class="space-y-6">
          <!-- Analysis Info -->
          <div class="flex flex-wrap gap-4 text-sm">
            <div class="flex items-center">
              <UIcon name="i-heroicons-calendar" class="w-4 h-4 mr-2 text-gray-500" />
              <span>{{ formatDate(selectedAnalysis.createdAt) }}</span>
            </div>
            <div class="flex items-center">
              <UIcon name="i-heroicons-photo" class="w-4 h-4 mr-2 text-gray-500" />
              <span>{{ selectedAnalysis.files.length }} fichiers</span>
            </div>
            <div class="flex items-center">
              <UIcon name="i-heroicons-shield-exclamation" class="w-4 h-4 mr-2 text-gray-500" />
              <span>{{ selectedAnalysis.result?.defects || 0 }} défauts détectés</span>
            </div>
          </div>
          
          <!-- Media Carousel -->
          <div class="relative bg-gray-100 dark:bg-gray-850 rounded-lg overflow-hidden">
            <!-- Carousel -->
            <div class="relative">
              <!-- Main Carousel -->
              <div class="aspect-video relative overflow-hidden rounded-lg">
                <div 
                  v-for="(file, fileIndex) in selectedAnalysis.files" 
                  :key="fileIndex"
                  class="absolute inset-0 transition-opacity duration-300"
                  :class="fileIndex === currentSlide ? 'opacity-100' : 'opacity-0 pointer-events-none'"
                >
                  <!-- Video -->
                  <!--<video 
                    v-if="isVideo(file!)" 
                    class="w-full h-full object-contain"
                    controls
                    :src="file"
                  ></video>-->
                  
                  <!-- Image -->
                  <!--<img 
                    v-else 
                    :src="file" 
                    :alt="`Analyse ${selectedAnalysisIndex + 1} - Image ${fileIndex + 1}`"
                    class="w-full h-full object-contain"
                  />-->
                </div>
              </div>
              
              <!-- Navigation Arrows -->
              <button 
                v-if="selectedAnalysis.files.length > 1"
                @click="prevSlide" 
                class="absolute left-2 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white rounded-full p-2 transition-colors duration-200 hover-scale"
                aria-label="Image précédente"
              >
                <UIcon name="i-heroicons-chevron-left" class="w-5 h-5" />
              </button>
              
              <button 
                v-if="selectedAnalysis.files.length > 1"
                @click="nextSlide" 
                class="absolute right-2 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white rounded-full p-2 transition-colors duration-200 hover-scale"
                aria-label="Image suivante"
              >
                <UIcon name="i-heroicons-chevron-right" class="w-5 h-5" />
              </button>
              
              <!-- Slide Counter -->
              <div 
                v-if="selectedAnalysis.files.length > 1"
                class="absolute bottom-4 right-4 bg-black/50 text-white text-xs px-2 py-1 rounded-md"
              >
                {{ currentSlide + 1 }} / {{ selectedAnalysis.files.length }}
              </div>
            </div>
            
            <!-- Thumbnails -->
            <div 
              v-if="selectedAnalysis.files.length > 1"
              class="flex gap-2 mt-4 overflow-x-auto pb-2 px-2"
            >
              <button
                v-for="(file, fileIndex) in selectedAnalysis.files"
                :key="fileIndex"
                @click="currentSlide = fileIndex"
                class="relative flex-shrink-0 w-20 h-20 rounded-md overflow-hidden transition-all duration-200 hover-scale"
                :class="fileIndex === currentSlide ? 'ring-2 ring-emerald-500' : 'opacity-70'"
              >
                <!-- Video Thumbnail -->
                <!--<div v-if="isVideo(file)" class="w-full h-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
                  <UIcon name="i-heroicons-film" class="w-8 h-8 text-gray-500 dark:text-gray-400" />
                </div>-->
                
                <!-- Image Thumbnail -->
                <!--<img 
                  v-else 
                  :src="file" 
                  :alt="`Thumbnail ${fileIndex + 1}`"
                  class="w-full h-full object-cover"
                />-->
              </button>
            </div>
          </div>
          
          <!-- Analysis Results -->
          <div v-if="selectedAnalysis.result" class="bg-gray-50 dark:bg-gray-850 rounded-lg p-4">
            <h4 class="font-medium text-gray-900 dark:text-white mb-3">Résultats de l'analyse</h4>
            
            <div class="space-y-3">
              <!-- Defects -->
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-600 dark:text-gray-400">Défauts détectés</span>
                <UBadge 
                  :color="getDefectSeverityColor(selectedAnalysis.result.defects)" 
                  variant="soft"
                >
                  {{ selectedAnalysis.result.defects || 0 }}
                </UBadge>
              </div>
              
              <!-- Severity -->
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-600 dark:text-gray-400">Niveau de sévérité</span>
                <UBadge 
                  :color="getSeverityColor(selectedAnalysis.result.severity)" 
                  variant="soft"
                >
                  {{ getSeverityText(selectedAnalysis.result.severity) }}
                </UBadge>
              </div>
              
              <!-- Progress Bar -->
              <div>
                <div class="flex items-center justify-between text-sm mb-1">
                  <span class="text-gray-600 dark:text-gray-400">État de la structure</span>
                  <span class="font-medium text-gray-900 dark:text-white">
                    {{ getStructureHealthPercent(selectedAnalysis.result) }}%
                  </span>
                </div>
                <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                  <div 
                    class="h-2 rounded-full transition-all duration-500 animate-glow"
                    :class="getStructureHealthColor(selectedAnalysis.result)"
                    :style="`width: ${getStructureHealthPercent(selectedAnalysis.result)}%`"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <template #footer>
          <div class="flex justify-between">
            <UButton
              @click="downloadAnalysisReport(selectedAnalysis!)"
              color="neutral"
              variant="soft"
            >
              <UIcon name="i-heroicons-arrow-down-tray" class="w-4 h-4 mr-2" />
              Télécharger le rapport
            </UButton>
            
            <UButton
              @click="showAnalysisModal = false"
              color="success"
            >
              Fermer
            </UButton>
          </div>
        </template>
      </UCard>
    </UModal>
    
    <!-- New Analysis Modal -->
    <UModal v-model:open="showNewAnalysisModal">
      <UCard>
        <template #header>
          <div class="flex items-center justify-between">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
              Nouvelle Analyse
            </h3>
            <UButton
              @click="showNewAnalysisModal = false"
              color="neutral"
              variant="ghost"
              size="sm"
            >
              <UIcon name="i-heroicons-x-mark" class="w-4 h-4" />
            </UButton>
          </div>
        </template>
        
        <div class="space-y-4">
          <!-- File Upload -->
          <div class="border-2 border-dashed border-gray-300 dark:border-gray-700 rounded-lg p-6 text-center">
            <UIcon name="i-heroicons-cloud-arrow-up" class="w-12 h-12 mx-auto text-gray-400 dark:text-gray-600 mb-4" />
            
            <h4 class="text-base font-medium text-gray-900 dark:text-white mb-2">
              Déposez vos fichiers ici
            </h4>
            
            <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">
              Formats supportés: JPG, PNG, MP4, MOV (max 50MB)
            </p>
            
            <UButton color="success" class="hover-scale">
              <UIcon name="i-heroicons-photo" class="w-4 h-4 mr-2" />
              Sélectionner des fichiers
            </UButton>
          </div>
          
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
                <!--<img 
                  :src="URL.createObjectURL(file)" 
                  :alt="`Preview ${index}`"
                  class="w-full h-full object-cover"
                />-->
                
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
          
          <!-- Analysis Options -->
          <UFormGroup label="Type d'analyse">
            <USelect
              v-model="newAnalysisType"
              :options="analysisTypes"
              placeholder="Sélectionner le type d'analyse"
            />
          </UFormGroup>
          
          <UFormGroup label="Notes (optionnel)">
            <UTextarea
              v-model="newAnalysisNotes"
              placeholder="Ajoutez des notes ou des observations..."
            />
          </UFormGroup>
        </div>
        
        <template #footer>
          <div class="flex justify-end space-x-3">
            <UButton
              @click="showNewAnalysisModal = false"
              color="neutral"
              variant="ghost"
            >
              Annuler
            </UButton>
            <UButton
              @click="createAnalysis"
              color="success"
              :loading="creatingAnalysis"
              :disabled="newAnalysisFiles.length === 0"
            >
              <UIcon name="i-heroicons-rocket-launch" class="w-4 h-4 mr-2" />
              Lancer l'analyse
            </UButton>
          </div>
        </template>
      </UCard>
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
const { initialize, getProjectById } = useProject()
const showAnalysisModal = ref(false)
const showNewAnalysisModal = ref(false)
const selectedAnalysisIndex = ref(0)
const currentSlide = ref(0)
const analysisSearchQuery = ref('')
const analysisSortBy = ref('newest')
const creatingAnalysis = ref(false)
const newAnalysisFiles = ref<File[]>([])
const newAnalysisType = ref('')
const newAnalysisNotes = ref('')
const project = ref<Project | null>(null)

// Initialize project data
watch(user, async (newUser) => {
  if (newUser) {
    initialize(newUser.uid)
    project.value = await getProjectById(projectId.value)
    console.log(project.value);
  }
})

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
    // This is a placeholder - in a real app you'd search through analysis metadata
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

// Analysis types
const analysisTypes = [
  { label: 'Détection de fissures', value: 'crack-detection' },
  { label: 'Analyse thermique', value: 'thermal-analysis' },
  { label: 'Inspection structurelle', value: 'structural-inspection' },
  { label: 'Détection d\'humidité', value: 'moisture-detection' }
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

const removeFile = (index: number) => {
  newAnalysisFiles.value.splice(index, 1)
}

const createAnalysis = async () => {
  if (newAnalysisFiles.value.length === 0 || !project.value) return
  
  creatingAnalysis.value = true
  
  try {
    // Mock API call
    await new Promise(resolve => setTimeout(resolve, 2000))
    
    // In a real app, you would upload files and process them
    const fileUrls = newAnalysisFiles.value.map(file => URL.createObjectURL(file))
    
    // Create new analysis
    const newAnalysis: Analysis = {
      files: fileUrls,
      result: { 
        defects: Math.floor(Math.random() * 5), 
        severity: ['low', 'medium', 'high'][Math.floor(Math.random() * 3)],
        health: Math.floor(Math.random() * 30) + 70
      },
      createdAt: new Date(),
      updatedAt: new Date()
    }
    
    // Add to project
    project.value.analysis.unshift(newAnalysis)
    project.value.updatedAt = new Date()
    
    // Reset form
    newAnalysisFiles.value = []
    newAnalysisType.value = ''
    newAnalysisNotes.value = ''
    
    // Close modal
    showNewAnalysisModal.value = false
    
    // Show success notification
    console.log('Analyse créée avec succès!')
    
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