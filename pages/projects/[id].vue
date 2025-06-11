<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <Header/>

    <div class="pt-20">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Implement loading later on if you want -->
         <div class="mb-8">
          <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div>
              <div class="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400 mb-2">
                <NuxtLink to="/inspections" class="hover:text-emerald-600 dark:hover:text-emerald-400 transition-colors">
                  Projets
                </NuxtLink>
                <UIcon name="i-heroicons-chevron-right" class="w-4 h-4" />
                <span class="truncate">{{ project?.name }}</span>
              </div>

              <div class="flex items-center gap-4 mt-2 text-sm text-gray-600 dark:text-gray-400">
                <div class="flex items-center">
                  <UIcon name="i-heroicons-calendar" class="w-4 h-4 mr-1" />
                  <span>Créé le {{ formatDate(project?.createdAt!) }}</span>
                </div>
                <div class="flex items-center">
                  <UIcon name="i-heroicons-chart-bar" class="w-4 h-4 mr-1" />
                  <span>{{ project?.analysis.length }} analyses</span>
                </div>
              </div>
            </div>

            
          </div>
         </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { Project } from '~/types';

const route = useRoute();
const { user } = useAuth(); 
const projectId = computed(() => route.params.id as string);
const project = ref<Project | null>(null);

const { initialize, getProjectById } = useProject();

watch(user, async (newUser) => {
  if (newUser) {
    initialize(newUser.uid);
    project.value = await getProjectById(projectId.value);
  }
});

const formatDate = (date: Date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  }).format(date)
}


</script>

<style>
</style>