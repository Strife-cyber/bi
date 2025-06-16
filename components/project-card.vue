<template>
  <div class="group relative bg-white dark:bg-gray-800 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 hover-lift animate-fade-in-up border border-gray-200 dark:border-gray-700 overflow-hidden">
    <!-- Project Header -->
    <div class="p-6 border-b border-gray-100 dark:border-gray-700">
      <div class="flex items-start justify-between">
        <div class="flex-1">
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-colors duration-300">
            {{ project.name }}
          </h3>
          <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
            Créé le {{ formatDate(project.createdAt) }}
          </p>
        </div>
        
        <!-- Project Status Badge -->
        <UBadge 
          :color="getStatusColor(project)" 
          variant="soft" 
          size="sm"
          class="animate-pulse-slow text-green-300"
        >
          {{ getStatusText(project) }}
        </UBadge>
      </div>
    </div>

    <!-- Project Stats -->
    <div class="p-6">
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div class="text-center">
          <div class="text-2xl font-bold text-emerald-600 dark:text-emerald-400 animate-float">
            {{ project.analysis.length }}
          </div>
          <div class="text-xs text-gray-500 dark:text-gray-400">
            Analyses
          </div>
        </div>
        <div class="text-center">
          <div class="text-2xl font-bold text-blue-600 dark:text-blue-400 animate-float" style="animation-delay: 100ms">
            {{ getTotalFiles(project) }}
          </div>
          <div class="text-xs text-gray-500 dark:text-gray-400">
            Fichiers
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="flex items-center justify-between text-sm text-gray-500 dark:text-gray-400 mb-4">
        <span>Dernière activité</span>
        <span>{{ getLastActivity(project) }}</span>
      </div>

      <!-- Progress Bar -->
      <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2 mb-4">
        <div 
          class="bg-gradient-to-r from-emerald-500 to-teal-600 h-2 rounded-full transition-all duration-500 animate-glow"
          :style="`width: ${getCompletionRate(project)}%`"
        ></div>
      </div>

      <!-- Action Buttons -->
      <div class="flex space-x-2 dark:text-white">
        <UButton
          @click="$emit('open-project', project)"
          color="primary"
          variant="solid"
          size="sm"
          class="flex-1 hover-scale cursor-pointer"
        >
          <UIcon name="i-heroicons-folder-open" class="w-4 h-4 mr-2" />
          Ouvrir
        </UButton>
        
        <UDropdown 
          :items="projectActions"
          :popper="{ placement: 'bottom-end' }"
        >
          <UButton
            color="neutral"
            variant="ghost"
            size="sm"
            class="hover-scale"
          >
            <UIcon name="i-heroicons-ellipsis-vertical" class="w-4 h-4" />
          </UButton>
        </UDropdown>
      </div>
    </div>

    <!-- Hover Effect Overlay -->
    <div class="absolute inset-0 bg-gradient-to-r from-emerald-500/5 to-teal-600/5 opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none"></div>
  </div>
</template>

<script setup lang="ts">
import { format } from 'timeago.js'
import type { Project } from '~/types'

// Props
const props = defineProps({
  project: {
    type: Object as PropType<Project>,
    required: true
  }
})

// Emits
const emit = defineEmits(['open-project', 'edit-project', 'delete-project'])

// Project actions dropdown
const projectActions = [
  [
    {
      label: 'Modifier',
      icon: 'i-heroicons-pencil',
      click: () => emit('edit-project', props.project)
    },
    {
      label: 'Dupliquer',
      icon: 'i-heroicons-document-duplicate',
      click: () => console.log('Duplicate project')
    }
  ],
  [
    {
      label: 'Exporter',
      icon: 'i-heroicons-arrow-down-tray',
      click: () => console.log('Export project')
    },
    {
      label: 'Partager',
      icon: 'i-heroicons-share',
      click: () => console.log('Share project')
    }
  ],
  [
    {
      label: 'Supprimer',
      icon: 'i-heroicons-trash',
      click: () => emit('delete-project', props.project)
    }
  ]
]

// Computed methods
const formatDate = (date: Date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  }).format(date)
}

const getStatusColor = (project: Project) => {
  if (project.analysis.length === 0) return 'neutral'
  if (project.analysis.length < 5) return 'warning'
  return 'success'
}

const getStatusText = (project: Project) => {
  if (project.analysis.length === 0) return 'Nouveau'
  if (project.analysis.length < 5) return 'En cours'
  return 'Actif'
}

const getTotalFiles = (project: Project) => {
  return project.analysis.reduce((total, analysis) => total + analysis.files.length, 0)
}

const getLastActivity = (project: Project) => {
  if (project.analysis.length === 0) return 'Aucune'
  
  const lastAnalysis = project.analysis.reduce((latest, current) => 
    current.updatedAt > latest.updatedAt ? current : latest
  )

  return format(lastAnalysis.updatedAt);
}

const getCompletionRate = (project: Project) => {
  if (project.analysis.length === 0) return 0
  return Math.min(100, (project.analysis.length / 10) * 100)
}
</script>
