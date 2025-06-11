<template>
  <div class="text-center py-16 animate-fade-in-up">
    <div class="mx-auto w-24 h-24 bg-gradient-to-br from-emerald-100 to-teal-100 dark:from-emerald-900 dark:to-teal-900 rounded-full flex items-center justify-center mb-6 animate-morphing">
      <UIcon name="i-heroicons-folder-plus" class="w-12 h-12 text-emerald-600 dark:text-emerald-400 animate-float" />
    </div>
    
    <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-2">
      Aucun projet pour le moment
    </h3>
    
    <p class="text-gray-500 dark:text-gray-400 mb-8 max-w-md mx-auto">
      Commencez votre première inspection en créant un nouveau projet. 
      Analysez vos bâtiments avec l'intelligence artificielle.
    </p>
    
    <UButton
      @click="$emit('create-project')"
      color="emerald"
      size="lg"
      class="hover-scale animate-glow dark:text-gray-200 cursor-pointer"
    >
      <UIcon name="i-heroicons-plus" class="w-5 h-5 mr-2" />
      Créer mon premier projet
    </UButton>
    
    <!-- Decorative Elements -->
    <div class="mt-12 grid grid-cols-3 gap-8 max-w-lg mx-auto opacity-50">
      <div class="text-center animate-fade-in-up" style="animation-delay: 200ms">
        <div class="w-12 h-12 bg-emerald-100 dark:bg-emerald-900 rounded-lg flex items-center justify-center mx-auto mb-2">
          <UIcon name="i-heroicons-camera" class="w-6 h-6 text-emerald-600 dark:text-emerald-400" />
        </div>
        <p class="text-xs text-gray-400">Capturer</p>
      </div>
      
      <div class="text-center animate-fade-in-up" style="animation-delay: 400ms">
        <div class="w-12 h-12 bg-blue-100 dark:bg-blue-900 rounded-lg flex items-center justify-center mx-auto mb-2">
          <UIcon name="i-heroicons-cpu-chip" class="w-6 h-6 text-blue-600 dark:text-blue-400" />
        </div>
        <p class="text-xs text-gray-400">Analyser</p>
      </div>
      
      <div class="text-center animate-fade-in-up" style="animation-delay: 600ms">
        <div class="w-12 h-12 bg-purple-100 dark:bg-purple-900 rounded-lg flex items-center justify-center mx-auto mb-2">
          <UIcon name="i-heroicons-document-text" class="w-6 h-6 text-purple-600 dark:text-purple-400" />
        </div>
        <p class="text-xs text-gray-400">Rapporter</p>
      </div>
    </div>
  </div>
</template>

<script setup>
const emit = defineEmits(['create-project'])
</script>
