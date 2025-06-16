<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Header Component -->
    <Header />
    
    <!-- Main Content -->
    <div class="pt-24">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Page Header -->
        <div class="mb-8 animate-fade-in-down">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h1 class="text-3xl font-bold text-gray-900 dark:text-white">
                Mes Inspections
              </h1>
              <p class="mt-2 text-gray-600 dark:text-gray-400">
                Gérez vos inspections et analyses de bâtiments
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
              
              <!-- Create Project Button -->
              <UButton
                @click="showCreateDrawer = true"
                color="secondary"
                size="md"
                class="hover-scale border cursor-pointer dark:text-gray-100"
              >
                <UIcon name="i-heroicons-plus" class="w-4 h-4 mr-2" />
                Nouveau Projet
              </UButton>
            </div>
          </div>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <div 
            v-for="(stat, index) in stats" 
            :key="stat.label"
            class="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 hover-lift animate-fade-in-up border border-gray-200 dark:border-gray-700"
            :style="`animation-delay: ${index * 100}ms`"
          >
            <div class="flex items-center">
              <div :class="`w-12 h-12 rounded-lg flex items-center justify-center ${stat.bgColor}`">
                <UIcon :name="stat.icon" :class="`w-6 h-6 ${stat.iconColor} animate-float`" />
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600 dark:text-gray-400">{{ stat.label }}</p>
                <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ stat.value }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Projects Grid -->
        <div>
          <!-- Filter Tabs -->
          <div class="mb-6 animate-fade-in-left">
            <div class="border-b border-gray-200 dark:border-gray-700">
              <nav class="-mb-px flex space-x-8">
                <button
                  v-for="filter in filters"
                  :key="filter.key"
                  @click="activeFilter = filter.key"
                  :class="[
                    'py-2 px-1 border-b-2 font-medium text-sm transition-colors duration-300',
                    activeFilter === filter.key
                      ? 'border-emerald-500 text-emerald-600 dark:text-emerald-400'
                      : 'border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300 hover:border-gray-300'
                  ]"
                >
                  {{ filter.label }}
                  <UBadge 
                    v-if="filter.count > 0"
                    :color="activeFilter === filter.key ? 'primary' : 'neutral'"
                    variant="soft"
                    size="xs"
                    class="ml-2"
                  >
                    {{ filter.count }}
                  </UBadge>
                </button>
              </nav>
            </div>
          </div>

          <!-- Projects Grid -->
          <div v-if="filteredProjects.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <ProjectCard
              v-for="(project, index) in filteredProjects"
              :key="project.id"
              :project="project"
              :style="`animation-delay: ${index * 100}ms`"
              @open-project="openProject"
              @edit-project="editProject"
              @delete-project="deleteProject"
            />
          </div>

          <!-- Empty State -->
          <ProjectEmptyState
            v-else
            @create-project="showCreateDrawer = true"
          />

          <!-- Load More Button -->
          <div v-if="hasMoreProjects" class="text-center mt-8 animate-fade-in-up">
            <UButton
              @click="loadMoreProjects"
              variant="outline"
              size="lg"
              :loading="loadingMore"
              class="hover-scale"
            >
              <UIcon name="i-heroicons-arrow-down" class="w-4 h-4 mr-2" />
              Charger plus de projets
            </UButton>
          </div>
        </div>
      </div>
    </div>

    <!-- Create Project Drawer -->
    <USlideover 
      title="Nouveau Projet"
      description="Creer un nouveau projet avec nom et description"
      slide="left"
      v-model:open="showCreateDrawer"
      :overlay="true" 
      :key="showCreateDrawer ? 'open': 'closed'"
      :ui="{ footer: 'justify-end' }"
    >
      <template #header></template>
      <template #body>
        <div class="p-6">
          <!-- Example form content -->
          <UForm :state="newProject" :validate="validateProject" @submit="submit" class="space-y-6">
            <UFormField label="Nom du projet" name="name">
              <UInput v-model="newProject.name" class="border-1 border-gray-400 p-2 w-full rounded-md"/>
            </UFormField>

            <UFormField label="Description" name="description">
              <UTextarea v-model="newProject.description" class="border-1 border-gray-400 p-2 w-full rounded-md"/>
            </UFormField>

            <UButton type="submit" color="primary" :loading="creating" class="bg-green-400 rounded-md w-full p-3 cursor-pointer flex items-center justify-center">
              Créer
            </UButton>
          </UForm>
        </div>
      </template>
      <template #footer>
        <UButton label="Close" class="bg-green-400 rounded-md p-3 cursor-pointer dark:text-white" variant="outline" @click="showCreateDrawer = false" />
      </template>
    </USlideover>

  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import type { Project } from '~/types';
import { definePageMeta, navigateTo } from '#imports';
import type { FormError, FormSubmitEvent } from '@nuxt/ui';

// Page metadata
definePageMeta({
  title: 'Mes Projets - Bâtiment Intelligent',
  description: 'Gérez vos projets d\'inspection et d\'analyse de bâtiments'
})

// Reactive data
const projects = ref<Project[]>([])
const searchQuery = ref('')
const activeFilter = ref('all')
const showCreateDrawer = ref(false)
const creating = ref(false)
const loadingMore = ref(false)
const hasMoreProjects = ref(false)

const { user } = useAuth();
const { initialize, getProjects, createProject, getAnalysisForProject } = useProject();
const { addNotification, initialize: initializeNotifications } = useNotifications();

watch(user, async (newUser) => {
  if (newUser) {
    initialize(newUser.uid);
    initializeNotifications(newUser.uid);
    projects.value = await getProjects();

    const analysisPromises = projects.value.map(async (project) => {
      project.analysis = await getAnalysisForProject(project.id);
      return project;
    });

    projects.value = await Promise.all(analysisPromises);
  }
})

// New project form
const newProject = reactive({
  name: undefined,
  description: undefined
});

const validateProject = (state: any): FormError[] => {
  const errors = []

  if (!state.name) errors.push({ name: 'name', message: 'required' })
  if (!state.description) errors.push({ name: 'description', message: 'required' })

  return errors;
}

// Computed properties
const stats = computed(() => [
  {
    label: 'Total Projets',
    value: projects.value.length,
    icon: 'i-heroicons-folder',
    bgColor: 'bg-emerald-100 dark:bg-emerald-900',
    iconColor: 'text-emerald-600 dark:text-emerald-400'
  },
  {
    label: 'Analyses',
    value: projects.value.reduce((total, p) => total + p.analysis.length, 0),
    icon: 'i-heroicons-cpu-chip',
    bgColor: 'bg-blue-100 dark:bg-blue-900',
    iconColor: 'text-blue-600 dark:text-blue-400'
  },
  {
    label: 'Fichiers',
    value: projects.value.reduce((total, p) => 
      total + p.analysis.reduce((sum, a) => sum + a.files.length, 0), 0
    ),
    icon: 'i-heroicons-photo',
    bgColor: 'bg-purple-100 dark:bg-purple-900',
    iconColor: 'text-purple-600 dark:text-purple-400'
  },
  {
    label: 'Cette semaine',
    value: projects.value.filter(p => 
      new Date(p.updatedAt) > new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
    ).length,
    icon: 'i-heroicons-calendar',
    bgColor: 'bg-orange-100 dark:bg-orange-900',
    iconColor: 'text-orange-600 dark:text-orange-400'
  }
])

const filters = computed(() => [
  {
    key: 'all',
    label: 'Tous',
    count: projects.value.length
  },
  {
    key: 'active',
    label: 'Actifs',
    count: projects.value.filter(p => p.analysis.length > 0).length
  },
  {
    key: 'recent',
    label: 'Récents',
    count: projects.value.filter(p => 
      new Date(p.updatedAt) > new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
    ).length
  }
])

const filteredProjects = computed(() => {
  let filtered = projects.value

  // Apply search filter
  if (searchQuery.value) {
    filtered = filtered.filter(p => 
      p.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }

  // Apply active filter
  switch (activeFilter.value) {
    case 'active':
      filtered = filtered.filter(p => p.analysis.length > 0)
      break
    case 'recent':
      filtered = filtered.filter(p => 
        new Date(p.updatedAt) > new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
      )
      break
  }

  return filtered
})

async function submit(event: FormSubmitEvent<typeof newProject>) {
  creating.value = true
  await createProject({
    name: event.data.name!,
    description: event.data.description!,
    createdAt: new Date(),
    updatedAt: new Date(),
    analysis: []
  });
  await addNotification(`Project ${event.data.name} successfully created`);
  showCreateDrawer.value = false;
}

const openProject = (project: Project) => {
  // TODO: Navigate to project detail page
  console.log('Opening project:', project.id)
  navigateTo(`/projects/${project.id}`)
}

const editProject = (project: Project) => {
  // TODO: Open edit modal
  console.log('Editing project:', project.id)
}

const deleteProject = (project: Project) => {
  // TODO: Show confirmation modal and delete
  console.log('Deleting project:', project.id)
}

const loadMoreProjects = async () => {
  loadingMore.value = true
  
  try {
    // TODO: Load more projects from API
    await new Promise(resolve => setTimeout(resolve, 1000))
    hasMoreProjects.value = false
  } catch (error) {
    console.error('Erreur lors du chargement:', error)
  } finally {
    loadingMore.value = false
  }
}
</script>
