<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 dark:text-white">
    <!-- Header Component -->
    <Header />
    
    <!-- Main Content -->
    <div class="pt-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Page Header -->
        <div class="mb-12 text-center animate-fade-in-down">
          <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-full mb-6 animate-morphing">
            <UIcon name="i-heroicons-scale" class="w-8 h-8 text-white animate-float" />
          </div>
          
          <h1 class="text-4xl font-bold text-gray-900 dark:text-white mb-4">
            Réglementations & Normes de Construction
          </h1>
          
          <p class="text-xl text-gray-600 dark:text-gray-400 max-w-3xl mx-auto">
            Guide complet des lois camerounaises et des standards internationaux 
            pour la construction et l'inspection des bâtiments
          </p>
        </div>

        <!-- Quick Navigation -->
        <div class="mb-12 animate-fade-in-up">
          <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 p-6">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">Navigation Rapide</h2>
            
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
              <UButton
                v-for="(section, index) in quickNavSections"
                :key="section.id"
                @click="scrollToSection(section.id)"
                variant="soft"
                color="success"
                class="justify-start hover-scale animate-fade-in-up"
                :style="`animation-delay: ${index * 100}ms`"
              >
                <UIcon :name="section.icon" class="w-4 h-4 mr-2" />
                {{ section.title }}
              </UButton>
            </div>
          </div>
        </div>

        <!-- Cameroon Construction Laws -->
        <section id="cameroon-laws" class="mb-16 animate-fade-in-up">
          <div class="flex items-center mb-8">
            <div class="w-12 h-12 bg-gradient-to-br from-green-500 to-emerald-600 rounded-lg flex items-center justify-center mr-4 animate-glow">
              <UIcon name="i-heroicons-flag" class="w-6 h-6 text-white animate-float" />
            </div>
            <div>
              <h2 class="text-3xl font-bold text-gray-900 dark:text-white">
                Lois de Construction au Cameroun
              </h2>
              <p class="text-gray-600 dark:text-gray-400 mt-1">
                Cadre juridique et réglementaire national
              </p>
            </div>
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <!-- Primary Laws -->
            <div 
              v-for="(law, index) in cameroonLaws" 
              :key="law.id"
              class="bg-white dark:bg-gray-800 rounded-xl shadow-md hover:shadow-lg transition-all duration-300 hover-lift animate-fade-in-up border border-gray-200 dark:border-gray-700"
              :style="`animation-delay: ${index * 150}ms`"
            >
              <div class="p-6">
                <div class="flex items-start justify-between mb-4">
                  <div class="flex items-center">
                    <div :class="`w-10 h-10 rounded-lg flex items-center justify-center mr-3 ${law.bgColor}`">
                      <UIcon :name="law.icon" :class="`w-5 h-5 ${law.iconColor} animate-float`" />
                    </div>
                    <div>
                      <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
                        {{ law.title }}
                      </h3>
                      <p class="text-sm text-gray-500 dark:text-gray-400">
                        {{ law.reference }}
                      </p>
                    </div>
                  </div>
                  
                  <UBadge 
                    :color="law.status === 'active' ? 'success' : 'warning'" 
                    variant="soft"
                    class="animate-pulse-slow"
                  >
                    {{ law.status === 'active' ? 'En vigueur' : 'En révision' }}
                  </UBadge>
                </div>

                <p class="text-gray-600 dark:text-gray-400 mb-4 text-sm leading-relaxed">
                  {{ law.description }}
                </p>

                <!-- Key Points -->
                <div class="mb-4">
                  <h4 class="text-sm font-medium text-gray-900 dark:text-white mb-2">Points clés :</h4>
                  <ul class="space-y-1">
                    <li 
                      v-for="point in law.keyPoints" 
                      :key="point"
                      class="flex items-start text-sm text-gray-600 dark:text-gray-400"
                    >
                      <UIcon name="i-heroicons-check-circle" class="w-4 h-4 text-emerald-500 mr-2 mt-0.5 flex-shrink-0" />
                      {{ point }}
                    </li>
                  </ul>
                </div>

                <!-- Actions -->
                <div class="flex items-center justify-between pt-4 border-t border-gray-200 dark:border-gray-700">
                  <div class="text-xs text-gray-500 dark:text-gray-400">
                    Dernière mise à jour: {{ law.lastUpdated }}
                  </div>
                  
                  <div class="flex space-x-2">
                    <UButton
                      v-if="law.downloadUrl"
                      :href="law.downloadUrl"
                      target="_blank"
                      size="xs"
                      variant="soft"
                      color="success"
                      class="hover-scale"
                    >
                      <UIcon name="i-heroicons-arrow-down-tray" class="w-3 h-3 mr-1" />
                      PDF
                    </UButton>
                    
                    <UButton
                      v-if="law.officialUrl"
                      :href="law.officialUrl"
                      target="_blank"
                      size="xs"
                      variant="soft"
                      class="hover-scale"
                    >
                      <UIcon name="i-heroicons-link" class="w-3 h-3 mr-1" />
                      Officiel
                    </UButton>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- International Standards -->
        <section id="international-standards" class="mb-16 animate-fade-in-up">
          <div class="flex items-center mb-8">
            <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-lg flex items-center justify-center mr-4 animate-glow">
              <UIcon name="i-heroicons-globe-alt" class="w-6 h-6 text-white animate-float" />
            </div>
            <div>
              <h2 class="text-3xl font-bold text-gray-900 dark:text-white">
                Normes Internationales
              </h2>
              <p class="text-gray-600 dark:text-gray-400 mt-1">
                Standards et certifications reconnus mondialement
              </p>
            </div>
          </div>

          <!-- Standards Categories -->
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            <div 
              v-for="(category, index) in standardCategories" 
              :key="category.id"
              class="bg-white dark:bg-gray-800 rounded-xl shadow-md hover:shadow-lg transition-all duration-300 hover-lift animate-fade-in-up border border-gray-200 dark:border-gray-700"
              :style="`animation-delay: ${index * 100}ms`"
            >
              <div class="p-6">
                <div class="flex items-center mb-4">
                  <div :class="`w-10 h-10 rounded-lg flex items-center justify-center mr-3 ${category.bgColor}`">
                    <UIcon :name="category.icon" :class="`w-5 h-5 ${category.iconColor} animate-float`" />
                  </div>
                  <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
                    {{ category.title }}
                  </h3>
                </div>

                <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">
                  {{ category.description }}
                </p>

                <div class="space-y-2">
                  <div 
                    v-for="standard in category.standards" 
                    :key="standard.code"
                    class="flex items-center justify-between p-2 bg-gray-50 dark:bg-gray-800 rounded-md hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
                  >
                    <div>
                      <div class="text-sm font-medium text-gray-900 dark:text-white">
                        {{ standard.code }}
                      </div>
                      <div class="text-xs text-gray-500 dark:text-gray-400">
                        {{ standard.title }}
                      </div>
                    </div>
                    
                    <UButton
                      v-if="standard.url"
                      :href="standard.url"
                      target="_blank"
                      size="xs"
                      variant="ghost"
                      class="hover-scale"
                    >
                      <UIcon name="i-heroicons-arrow-top-right-on-square" class="w-3 h-3" />
                    </UButton>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Building Codes -->
        <section id="building-codes" class="mb-16 animate-fade-in-up">
          <div class="flex items-center mb-8">
            <div class="w-12 h-12 bg-gradient-to-br from-purple-500 to-pink-600 rounded-lg flex items-center justify-center mr-4 animate-glow">
              <UIcon name="i-heroicons-building-office-2" class="w-6 h-6 text-white animate-float" />
            </div>
            <div>
              <h2 class="text-3xl font-bold text-gray-900 dark:text-white">
                Codes du Bâtiment
              </h2>
              <p class="text-gray-600 dark:text-gray-400 mt-1">
                Réglementations techniques et normes de construction
              </p>
            </div>
          </div>

          <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
            <div class="p-6">
              <UTabs :items="buildingCodeTabs" class="w-full">
                <!-- @vue-expect-error -->
                <template #default="{ selectedIndex }">
                  <!-- Structural Codes -->
                  <div v-if="selectedIndex === 0" class="animate-fade-in">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div 
                        v-for="(code, index) in structuralCodes" 
                        :key="code.id"
                        class="border border-gray-200 dark:border-gray-700 rounded-lg p-4 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors animate-fade-in-up"
                        :style="`animation-delay: ${index * 100}ms`"
                      >
                        <div class="flex items-start justify-between mb-3">
                          <h4 class="text-base font-semibold text-gray-900 dark:text-white">
                            {{ code.title }}
                          </h4>
                          <UBadge 
                            :color="code.mandatory ? 'error' : 'primary'" 
                            variant="soft"
                            size="sm"
                          >
                            {{ code.mandatory ? 'Obligatoire' : 'Recommandé' }}
                          </UBadge>
                        </div>
                        
                        <p class="text-sm text-gray-600 dark:text-gray-400 mb-3">
                          {{ code.description }}
                        </p>
                        
                        <div class="flex items-center justify-between">
                          <span class="text-xs text-gray-500 dark:text-gray-400">
                            {{ code.scope }}
                          </span>
                          
                          <UButton
                            v-if="code.url"
                            :href="code.url"
                            target="_blank"
                            size="xs"
                            variant="soft"
                            color="success"
                            class="hover-scale"
                          >
                            <UIcon name="i-heroicons-document-text" class="w-3 h-3 mr-1" />
                            Consulter
                          </UButton>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Safety Codes -->
                  <div v-else-if="selectedIndex === 1" class="animate-fade-in">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div 
                        v-for="(code, index) in safetyCodes" 
                        :key="code.id"
                        class="border border-gray-200 dark:border-gray-700 rounded-lg p-4 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors animate-fade-in-up"
                        :style="`animation-delay: ${index * 100}ms`"
                      >
                        <div class="flex items-start justify-between mb-3">
                          <h4 class="text-base font-semibold text-gray-900 dark:text-white">
                            {{ code.title }}
                          </h4>
                          <UBadge 
                            :color="code.mandatory ? 'error' : 'primary'" 
                            variant="soft"
                            size="sm"
                          >
                            {{ code.mandatory ? 'Obligatoire' : 'Recommandé' }}
                          </UBadge>
                        </div>
                        
                        <p class="text-sm text-gray-600 dark:text-gray-400 mb-3">
                          {{ code.description }}
                        </p>
                        
                        <div class="flex items-center justify-between">
                          <span class="text-xs text-gray-500 dark:text-gray-400">
                            {{ code.scope }}
                          </span>
                          
                          <UButton
                            v-if="code.url"
                            :href="code.url"
                            target="_blank"
                            size="xs"
                            variant="soft"
                            color="success"
                            class="hover-scale"
                          >
                            <UIcon name="i-heroicons-document-text" class="w-3 h-3 mr-1" />
                            Consulter
                          </UButton>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Environmental Codes -->
                  <div v-else-if="selectedIndex === 2" class="animate-fade-in">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div 
                        v-for="(code, index) in environmentalCodes" 
                        :key="code.id"
                        class="border border-gray-200 dark:border-gray-700 rounded-lg p-4 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors animate-fade-in-up"
                        :style="`animation-delay: ${index * 100}ms`"
                      >
                        <div class="flex items-start justify-between mb-3">
                          <h4 class="text-base font-semibold text-gray-900 dark:text-white">
                            {{ code.title }}
                          </h4>
                          <UBadge 
                            :color="code.mandatory ? 'error' : 'primary'" 
                            variant="soft"
                            size="sm"
                          >
                            {{ code.mandatory ? 'Obligatoire' : 'Recommandé' }}
                          </UBadge>
                        </div>
                        
                        <p class="text-sm text-gray-600 dark:text-gray-400 mb-3">
                          {{ code.description }}
                        </p>
                        
                        <div class="flex items-center justify-between">
                          <span class="text-xs text-gray-500 dark:text-gray-400">
                            {{ code.scope }}
                          </span>
                          
                          <UButton
                            v-if="code.url"
                            :href="code.url"
                            target="_blank"
                            size="xs"
                            variant="soft"
                            color="success"
                            class="hover-scale"
                          >
                            <UIcon name="i-heroicons-document-text" class="w-3 h-3 mr-1" />
                            Consulter
                          </UButton>
                        </div>
                      </div>
                    </div>
                  </div>
                </template>
              </UTabs>
            </div>
          </div>
        </section>

        <!-- Regulatory Bodies -->
        <section id="regulatory-bodies" class="mb-16 animate-fade-in-up">
          <div class="flex items-center mb-8">
            <div class="w-12 h-12 bg-gradient-to-br from-orange-500 to-red-600 rounded-lg flex items-center justify-center mr-4 animate-glow">
              <UIcon name="i-heroicons-building-storefront" class="w-6 h-6 text-white animate-float" />
            </div>
            <div>
              <h2 class="text-3xl font-bold text-gray-900 dark:text-white">
                Organismes de Réglementation
              </h2>
              <p class="text-gray-600 dark:text-gray-400 mt-1">
                Institutions responsables de l'application des normes
              </p>
            </div>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div 
              v-for="(body, index) in regulatoryBodies" 
              :key="body.id"
              class="bg-white dark:bg-gray-800 rounded-xl shadow-md hover:shadow-lg transition-all duration-300 hover-lift animate-fade-in-up border border-gray-200 dark:border-gray-700"
              :style="`animation-delay: ${index * 100}ms`"
            >
              <div class="p-6">
                <div class="flex items-center mb-4">
                  <div :class="`w-12 h-12 rounded-lg flex items-center justify-center mr-4 ${body.bgColor}`">
                    <UIcon :name="body.icon" :class="`w-6 h-6 ${body.iconColor} animate-float`" />
                  </div>
                  <div>
                    <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
                      {{ body.name }}
                    </h3>
                    <p class="text-sm text-gray-500 dark:text-gray-400">
                      {{ body.acronym }}
                    </p>
                  </div>
                </div>

                <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">
                  {{ body.description }}
                </p>

                <div class="space-y-2 mb-4">
                  <div class="text-xs font-medium text-gray-900 dark:text-white">
                    Domaines de compétence :
                  </div>
                  <div class="flex flex-wrap gap-1">
                    <UBadge 
                      v-for="domain in body.domains" 
                      :key="domain"
                      variant="soft"
                      size="xs"
                      color="success"
                    >
                      {{ domain }}
                    </UBadge>
                  </div>
                </div>

                <div class="flex items-center justify-between pt-4 border-t border-gray-200 dark:border-gray-700">
                  <div class="text-xs text-gray-500 dark:text-gray-400">
                    {{ body.location }}
                  </div>
                  
                  <div class="flex space-x-2">
                    <UButton
                      v-if="body.website"
                      :href="body.website"
                      target="_blank"
                      size="xs"
                      variant="soft"
                      class="hover-scale"
                    >
                      <UIcon name="i-heroicons-globe-alt" class="w-3 h-3 mr-1" />
                      Site Web
                    </UButton>
                    
                    <UButton
                      v-if="body.contact"
                      :href="`mailto:${body.contact}`"
                      size="xs"
                      variant="soft"
                      color="success"
                      class="hover-scale"
                    >
                      <UIcon name="i-heroicons-envelope" class="w-3 h-3 mr-1" />
                      Contact
                    </UButton>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Resources & Downloads -->
        <section id="resources" class="mb-16 animate-fade-in-up">
          <div class="flex items-center mb-8">
            <div class="w-12 h-12 bg-gradient-to-br from-teal-500 to-cyan-600 rounded-lg flex items-center justify-center mr-4 animate-glow">
              <UIcon name="i-heroicons-document-arrow-down" class="w-6 h-6 text-white animate-float" />
            </div>
            <div>
              <h2 class="text-3xl font-bold text-gray-900 dark:text-white">
                Ressources & Téléchargements
              </h2>
              <p class="text-gray-600 dark:text-gray-400 mt-1">
                Documents officiels et guides pratiques
              </p>
            </div>
          </div>

          <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
            <div class="p-6">
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div 
                  v-for="(resource, index) in resources" 
                  :key="resource.id"
                  class="border border-gray-200 dark:border-gray-700 rounded-lg p-4 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-300 hover-lift animate-fade-in-up"
                  :style="`animation-delay: ${index * 100}ms`"
                >
                  <div class="flex items-start justify-between mb-3">
                    <div class="flex items-center">
                      <UIcon :name="resource.icon" class="w-5 h-5 text-emerald-600 dark:text-emerald-400 mr-2" />
                      <h4 class="text-sm font-semibold text-gray-900 dark:text-white">
                        {{ resource.title }}
                      </h4>
                    </div>
                    
                    <UBadge 
                      :color="resource.type === 'pdf' ? 'error' : resource.type === 'doc' ? 'primary' : 'success'" 
                      variant="soft"
                      size="xs"
                    >
                      {{ resource.type.toUpperCase() }}
                    </UBadge>
                  </div>
                  
                  <p class="text-xs text-gray-600 dark:text-gray-400 mb-3">
                    {{ resource.description }}
                  </p>
                  
                  <div class="flex items-center justify-between">
                    <span class="text-xs text-gray-500 dark:text-gray-400">
                      {{ resource.size }} • {{ resource.language }}
                    </span>
                    
                    <UButton
                      :href="resource.downloadUrl"
                      target="_blank"
                      size="xs"
                      variant="soft"
                      color="success"
                      class="hover-scale"
                    >
                      <UIcon name="i-heroicons-arrow-down-tray" class="w-3 h-3 mr-1" />
                      Télécharger
                    </UButton>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Contact & Support -->
        <section class="animate-fade-in-up">
          <div class="bg-gradient-to-r from-emerald-500 to-teal-600 rounded-xl shadow-lg p-8 text-center">
            <div class="max-w-2xl mx-auto">
              <UIcon name="i-heroicons-question-mark-circle" class="w-12 h-12 text-white mx-auto mb-4 animate-float" />
              
              <h2 class="text-2xl font-bold text-white mb-4">
                Besoin d'aide ou d'informations complémentaires ?
              </h2>
              
              <p class="text-emerald-100 mb-6">
                Notre équipe d'experts est disponible pour vous accompagner dans la compréhension 
                et l'application des réglementations de construction.
              </p>
              
              <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <UButton
                  href="mailto:support@batiment-intelligent.cm"
                  color="neutral"
                  size="lg"
                  class="hover-scale"
                >
                  <UIcon name="i-heroicons-envelope" class="w-5 h-5 mr-2" />
                  Nous Contacter
                </UButton>
                
                <UButton
                  href="tel:+237123456789"
                  variant="outline"
                  color="neutral"
                  size="lg"
                  class="hover-scale"
                >
                  <UIcon name="i-heroicons-phone" class="w-5 h-5 mr-2" />
                  +237 123 456 789
                </UButton>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

// Page metadata
definePageMeta({
  title: 'Réglementations & Normes - Bâtiment Intelligent',
  description: 'Guide complet des lois camerounaises et des standards internationaux pour la construction'
})

// Quick navigation sections
const quickNavSections = [
  {
    id: 'cameroon-laws',
    title: 'Lois Camerounaises',
    icon: 'i-heroicons-flag'
  },
  {
    id: 'international-standards',
    title: 'Normes Internationales',
    icon: 'i-heroicons-globe-alt'
  },
  {
    id: 'building-codes',
    title: 'Codes du Bâtiment',
    icon: 'i-heroicons-building-office-2'
  },
  {
    id: 'regulatory-bodies',
    title: 'Organismes',
    icon: 'i-heroicons-building-storefront'
  }
]

// Cameroon construction laws
const cameroonLaws = [
  {
    id: 'urban-planning-law',
    title: 'Loi sur l\'Urbanisme et l\'Aménagement',
    reference: 'Loi N° 2004/003 du 21 avril 2004',
    description: 'Cette loi régit l\'urbanisme et l\'aménagement du territoire au Cameroun. Elle définit les règles de planification urbaine, les procédures d\'obtention des permis de construire et les normes d\'aménagement.',
    keyPoints: [
      'Procédures d\'obtention des permis de construire',
      'Normes d\'aménagement urbain et rural',
      'Règles de lotissement et de morcellement',
      'Sanctions en cas de construction illégale'
    ],
    status: 'active',
    lastUpdated: '2004',
    icon: 'i-heroicons-map',
    bgColor: 'bg-blue-100 dark:bg-blue-900',
    iconColor: 'text-blue-600 dark:text-blue-400',
    downloadUrl: '#',
    officialUrl: 'https://www.minduh.gov.cm'
  },
  {
    id: 'building-safety-code',
    title: 'Code de Sécurité des Bâtiments',
    reference: 'Décret N° 2008/0737/PM du 23 avril 2008',
    description: 'Ce décret établit les normes de sécurité pour la construction des bâtiments, incluant les mesures de prévention incendie, les normes parasismiques et les exigences d\'accessibilité.',
    keyPoints: [
      'Normes de résistance au feu',
      'Exigences parasismiques',
      'Accessibilité pour personnes handicapées',
      'Systèmes d\'évacuation d\'urgence'
    ],
    status: 'active',
    lastUpdated: '2008',
    icon: 'i-heroicons-shield-check',
    bgColor: 'bg-red-100 dark:bg-red-900',
    iconColor: 'text-red-600 dark:text-red-400',
    downloadUrl: '#',
    officialUrl: 'https://www.mintp.gov.cm'
  },
  {
    id: 'environmental-law',
    title: 'Loi-cadre sur l\'Environnement',
    reference: 'Loi N° 96/12 du 5 août 1996',
    description: 'Cette loi établit le cadre juridique de la gestion de l\'environnement au Cameroun, incluant les études d\'impact environnemental obligatoires pour les projets de construction.',
    keyPoints: [
      'Études d\'impact environnemental',
      'Gestion des déchets de construction',
      'Protection des zones sensibles',
      'Normes de pollution sonore et atmosphérique'
    ],
    status: 'active',
    lastUpdated: '1996',
    icon: 'i-heroicons-leaf',
    bgColor: 'bg-green-100 dark:bg-green-900',
    iconColor: 'text-green-600 dark:text-green-400',
    downloadUrl: '#',
    officialUrl: 'https://www.minepded.gov.cm'
  },
  {
    id: 'construction-materials-law',
    title: 'Réglementation des Matériaux de Construction',
    reference: 'Arrêté N° 00001/MINTP du 15 janvier 2010',
    description: 'Cet arrêté définit les normes de qualité des matériaux de construction utilisés au Cameroun, les procédures de certification et les contrôles qualité obligatoires.',
    keyPoints: [
      'Normes de qualité des matériaux',
      'Procédures de certification',
      'Contrôles qualité obligatoires',
      'Sanctions pour matériaux non conformes'
    ],
    status: 'active',
    lastUpdated: '2010',
    icon: 'i-heroicons-cube',
    bgColor: 'bg-orange-100 dark:bg-orange-900',
    iconColor: 'text-orange-600 dark:text-orange-400',
    downloadUrl: '#',
    officialUrl: 'https://www.mintp.gov.cm'
  }
]

// International standards categories
const standardCategories = [
  {
    id: 'iso-standards',
    title: 'Normes ISO',
    description: 'Standards internationaux pour la qualité, sécurité et efficacité',
    icon: 'i-heroicons-globe-europe-africa',
    bgColor: 'bg-blue-100 dark:bg-blue-900',
    iconColor: 'text-blue-600 dark:text-blue-400',
    standards: [
      {
        code: 'ISO 9001',
        title: 'Systèmes de management de la qualité',
        url: 'https://www.iso.org/iso-9001-quality-management.html'
      },
      {
        code: 'ISO 14001',
        title: 'Systèmes de management environnemental',
        url: 'https://www.iso.org/iso-14001-environmental-management.html'
      },
      {
        code: 'ISO 45001',
        title: 'Systèmes de management de la santé et sécurité au travail',
        url: 'https://www.iso.org/iso-45001-occupational-health-and-safety.html'
      }
    ]
  },
  {
    id: 'en-standards',
    title: 'Normes Européennes (EN)',
    description: 'Standards européens adoptés par de nombreux pays africains',
    icon: 'i-heroicons-flag',
    bgColor: 'bg-purple-100 dark:bg-purple-900',
    iconColor: 'text-purple-600 dark:text-purple-400',
    standards: [
      {
        code: 'EN 1990',
        title: 'Eurocodes - Bases de calcul des structures',
        url: 'https://eurocodes.jrc.ec.europa.eu'
      },
      {
        code: 'EN 1991',
        title: 'Actions sur les structures',
        url: 'https://eurocodes.jrc.ec.europa.eu'
      },
      {
        code: 'EN 1992',
        title: 'Calcul des structures en béton',
        url: 'https://eurocodes.jrc.ec.europa.eu'
      }
    ]
  },
  {
    id: 'astm-standards',
    title: 'Normes ASTM',
    description: 'Standards américains pour les matériaux et essais',
    icon: 'i-heroicons-beaker',
    bgColor: 'bg-green-100 dark:bg-green-900',
    iconColor: 'text-green-600 dark:text-green-400',
    standards: [
      {
        code: 'ASTM C150',
        title: 'Spécification pour le ciment Portland',
        url: 'https://www.astm.org'
      },
      {
        code: 'ASTM A615',
        title: 'Barres d\'armature en acier déformé',
        url: 'https://www.astm.org'
      },
      {
        code: 'ASTM C33',
        title: 'Granulats pour béton',
        url: 'https://www.astm.org'
      }
    ]
  }
]

// Building code tabs
const buildingCodeTabs = [
  {
    label: 'Codes Structurels',
    icon: 'i-heroicons-building-office',
    value: 0
  },
  {
    label: 'Codes de Sécurité',
    icon: 'i-heroicons-shield-check',
    value: 1
  },
  {
    label: 'Codes Environnementaux',
    icon: 'i-heroicons-leaf',
    value: 2
  }
]

// Structural codes
const structuralCodes = [
  {
    id: 'concrete-code',
    title: 'Code du Béton Armé',
    description: 'Règles de calcul et de dimensionnement des structures en béton armé selon les normes camerounaises et internationales.',
    scope: 'Bâtiments résidentiels et commerciaux',
    mandatory: true,
    url: '#'
  },
  {
    id: 'steel-code',
    title: 'Code des Structures Métalliques',
    description: 'Normes pour la conception, le calcul et la construction des structures en acier.',
    scope: 'Structures industrielles et commerciales',
    mandatory: true,
    url: '#'
  },
  {
    id: 'foundation-code',
    title: 'Code des Fondations',
    description: 'Règles de conception et d\'exécution des fondations selon la nature du sol et les charges appliquées.',
    scope: 'Tous types de constructions',
    mandatory: true,
    url: '#'
  },
  {
    id: 'seismic-code',
    title: 'Code Parasismique',
    description: 'Règles de construction parasismique adaptées aux zones sismiques du Cameroun.',
    scope: 'Zones à risque sismique',
    mandatory: true,
    url: '#'
  }
]

// Safety codes
const safetyCodes = [
  {
    id: 'fire-code',
    title: 'Code de Prévention Incendie',
    description: 'Mesures de prévention et de protection contre l\'incendie dans les bâtiments.',
    scope: 'Bâtiments recevant du public',
    mandatory: true,
    url: '#'
  },
  {
    id: 'electrical-code',
    title: 'Code Électrique',
    description: 'Normes d\'installation électrique pour assurer la sécurité des occupants.',
    scope: 'Toutes installations électriques',
    mandatory: true,
    url: '#'
  },
  {
    id: 'accessibility-code',
    title: 'Code d\'Accessibilité',
    description: 'Normes d\'accessibilité pour les personnes à mobilité réduite.',
    scope: 'Bâtiments publics et commerciaux',
    mandatory: true,
    url: '#'
  },
  {
    id: 'ventilation-code',
    title: 'Code de Ventilation',
    description: 'Exigences de ventilation et de qualité de l\'air intérieur.',
    scope: 'Bâtiments résidentiels et commerciaux',
    mandatory: false,
    url: '#'
  }
]

// Environmental codes
const environmentalCodes = [
  {
    id: 'energy-code',
    title: 'Code de Performance Énergétique',
    description: 'Normes d\'efficacité énergétique et d\'isolation thermique des bâtiments.',
    scope: 'Nouveaux bâtiments',
    mandatory: false,
    url: '#'
  },
  {
    id: 'water-code',
    title: 'Code de Gestion de l\'Eau',
    description: 'Règles de gestion des eaux pluviales et de conservation de l\'eau.',
    scope: 'Tous projets de construction',
    mandatory: false,
    url: '#'
  },
  {
    id: 'waste-code',
    title: 'Code de Gestion des Déchets',
    description: 'Normes de gestion des déchets de construction et de démolition.',
    scope: 'Chantiers de construction',
    mandatory: true,
    url: '#'
  },
  {
    id: 'green-building-code',
    title: 'Code du Bâtiment Vert',
    description: 'Standards pour la construction durable et écologique.',
    scope: 'Projets de construction durable',
    mandatory: false,
    url: '#'
  }
]

// Regulatory bodies
const regulatoryBodies = [
  {
    id: 'mintp',
    name: 'Ministère des Travaux Publics',
    acronym: 'MINTP',
    description: 'Responsable de la réglementation et du contrôle des travaux publics et de la construction au Cameroun.',
    domains: ['Travaux Publics', 'Construction', 'Infrastructures'],
    location: 'Yaoundé, Cameroun',
    icon: 'i-heroicons-building-office-2',
    bgColor: 'bg-blue-100 dark:bg-blue-900',
    iconColor: 'text-blue-600 dark:text-blue-400',
    website: 'https://www.mintp.gov.cm',
    contact: 'info@mintp.gov.cm'
  },
  {
    id: 'minduh',
    name: 'Ministère du Développement Urbain et de l\'Habitat',
    acronym: 'MINDUH',
    description: 'Chargé de l\'urbanisme, de l\'habitat et du développement urbain durable.',
    domains: ['Urbanisme', 'Habitat', 'Développement Urbain'],
    location: 'Yaoundé, Cameroun',
    icon: 'i-heroicons-home-modern',
    bgColor: 'bg-green-100 dark:bg-green-900',
    iconColor: 'text-green-600 dark:text-green-400',
    website: 'https://www.minduh.gov.cm',
    contact: 'contact@minduh.gov.cm'
  },
  {
    id: 'anor',
    name: 'Agence de Normalisation et de Qualité',
    acronym: 'ANOR',
    description: 'Organisme national de normalisation responsable de l\'élaboration et de la promotion des normes.',
    domains: ['Normalisation', 'Qualité', 'Certification'],
    location: 'Douala, Cameroun',
    icon: 'i-heroicons-check-badge',
    bgColor: 'bg-purple-100 dark:bg-purple-900',
    iconColor: 'text-purple-600 dark:text-purple-400',
    website: 'https://www.anor.cm',
    contact: 'info@anor.cm'
  },
  {
    id: 'minepded',
    name: 'Ministère de l\'Environnement',
    acronym: 'MINEPDED',
    description: 'Responsable de la protection de l\'environnement et des études d\'impact environnemental.',
    domains: ['Environnement', 'Études d\'Impact', 'Développement Durable'],
    location: 'Yaoundé, Cameroun',
    icon: 'i-heroicons-leaf',
    bgColor: 'bg-emerald-100 dark:bg-emerald-900',
    iconColor: 'text-emerald-600 dark:text-emerald-400',
    website: 'https://www.minepded.gov.cm',
    contact: 'contact@minepded.gov.cm'
  },
  {
    id: 'ordre-architectes',
    name: 'Ordre National des Architectes',
    acronym: 'ONA',
    description: 'Organisation professionnelle des architectes du Cameroun, responsable de la déontologie et de la formation.',
    domains: ['Architecture', 'Déontologie', 'Formation'],
    location: 'Yaoundé, Cameroun',
    icon: 'i-heroicons-academic-cap',
    bgColor: 'bg-orange-100 dark:bg-orange-900',
    iconColor: 'text-orange-600 dark:text-orange-400',
    website: 'https://www.ona-cameroun.org',
    contact: 'secretariat@ona-cameroun.org'
  },
  {
    id: 'ordre-ingenieurs',
    name: 'Ordre National des Ingénieurs',
    acronym: 'ONI',
    description: 'Organisation professionnelle des ingénieurs, garante de l\'éthique et de la compétence technique.',
    domains: ['Ingénierie', 'Contrôle Technique', 'Formation'],
    location: 'Douala, Cameroun',
    icon: 'i-heroicons-cog-6-tooth',
    bgColor: 'bg-red-100 dark:bg-red-900',
    iconColor: 'text-red-600 dark:text-red-400',
    website: 'https://www.oni-cameroun.org',
    contact: 'contact@oni-cameroun.org'
  }
]

// Resources and downloads
const resources = [
  {
    id: 'urban-planning-guide',
    title: 'Guide de l\'Urbanisme au Cameroun',
    description: 'Manuel complet des procédures d\'urbanisme et d\'aménagement',
    type: 'pdf',
    size: '2.5 MB',
    language: 'Français',
    icon: 'i-heroicons-document-text',
    downloadUrl: '#'
  },
  {
    id: 'building-permit-form',
    title: 'Formulaire de Demande de Permis de Construire',
    description: 'Formulaire officiel pour les demandes de permis de construire',
    type: 'pdf',
    size: '500 KB',
    language: 'Français',
    icon: 'i-heroicons-document',
    downloadUrl: '#'
  },
  {
    id: 'safety-checklist',
    title: 'Liste de Contrôle Sécurité Chantier',
    description: 'Check-list pour la sécurité sur les chantiers de construction',
    type: 'doc',
    size: '1.2 MB',
    language: 'Français',
    icon: 'i-heroicons-clipboard-document-check',
    downloadUrl: '#'
  },
  {
    id: 'material-standards',
    title: 'Normes des Matériaux de Construction',
    description: 'Spécifications techniques des matériaux de construction',
    type: 'pdf',
    size: '3.8 MB',
    language: 'Français',
    icon: 'i-heroicons-cube',
    downloadUrl: '#'
  },
  {
    id: 'environmental-impact-guide',
    title: 'Guide d\'Étude d\'Impact Environnemental',
    description: 'Méthodologie pour les études d\'impact environnemental',
    type: 'pdf',
    size: '4.2 MB',
    language: 'Français',
    icon: 'i-heroicons-leaf',
    downloadUrl: '#'
  },
  {
    id: 'accessibility-standards',
    title: 'Normes d\'Accessibilité PMR',
    description: 'Standards d\'accessibilité pour personnes à mobilité réduite',
    type: 'pdf',
    size: '1.8 MB',
    language: 'Français',
    icon: 'i-heroicons-user-group',
    downloadUrl: '#'
  }
]

// Methods
const scrollToSection = (sectionId: string) => {
  const element = document.getElementById(sectionId)
  if (element) {
    element.scrollIntoView({ behavior: 'smooth' })
  }
}
</script>
