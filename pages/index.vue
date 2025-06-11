<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 overflow-x-hidden">
    <!-- Navigation -->
    <nav class="fixed top-0 w-full glass-effect bg-white/90 dark:bg-gray-900/90 backdrop-blur-md border-b border-emerald-100 dark:border-emerald-800 z-50 animate-slide-in-down">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
          <div class="flex items-center space-x-2 animate-fade-in-left">
            <div class="h-8 w-8 text-emerald-600 animate-glow animate-morphing bg-gradient-to-br from-emerald-500 to-teal-600 rounded-lg flex items-center justify-center">
              <span class="text-white font-bold text-sm">BI</span>
            </div>
            <span class="text-xl font-bold text-gradient animate-typewriter">Bâtiment Intelligent</span>
          </div>
          
          <div class="hidden md:flex items-center space-x-8 animate-fade-in-down">
            <a href="#features" class="text-gray-600 dark:text-gray-300 text-sm hover:text-emerald-600 dark:hover:text-emerald-400 transition-all duration-300 hover-lift relative group">
              Fonctionnalités
              <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-emerald-500 transition-all duration-300 group-hover:w-full"></span>
            </a>
            <a href="#technology" class="text-gray-600 dark:text-gray-300 text-sm hover:text-emerald-600 dark:hover:text-emerald-400 transition-all duration-300 hover-lift relative group">
              Technologie
              <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-emerald-500 transition-all duration-300 group-hover:w-full"></span>
            </a>
            <a href="#contact" class="text-gray-600 dark:text-gray-300 text-sm hover:text-emerald-600 dark:hover:text-emerald-400 transition-all duration-300 hover-lift relative group">
              Contact
              <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-emerald-500 transition-all duration-300 group-hover:w-full"></span>
            </a>
          </div>
          
          <div v-if="user==null" class="hidden md:flex items-center space-x-4 animate-fade-in-right">
            <router-link to="/auth/register" class="btn-ghost hover-scale cursor-pointer">
              S'inscrire
            </router-link>
            <router-link to="/auth/login" class="btn-primary hover-glow cursor-pointer">
              Connexion
            </router-link>
          </div>
          <div v-else class="hidden md:flex items-center space-x-4 animate-fade-in-right">
            <router-link to="/dashboard"  class="btn-primary hover-scale cursor-pointer">
              Dashboard
            </router-link>
          </div>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="pt-20 pb-16 bg-emerald-50 dark:bg-gray-800 min-h-screen flex items-center relative overflow-hidden">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div class="grid lg:grid-cols-2 gap-12 items-center">
          <div class="space-y-8 animate-fade-in-up">
            <div class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium bg-emerald-100 dark:bg-emerald-900 text-emerald-800 dark:text-emerald-200 animate-bounce-in card-glass">
              <div class="h-4 w-4 mr-2 animate-spin-slow text-emerald-600">✨</div>
              Projet Pilote - Douala & Yaoundé
            </div>
            
            <h1 class="text-4xl lg:text-6xl font-bold text-gray-900 dark:text-white leading-tight">
              <span class="animate-fade-in-right" style="animation-delay: 0.2s">Système d'Analyse</span><br>
              <span class="text-gradient animate-shimmer animate-fade-in-right" style="animation-delay: 0.4s">
                Écologique
              </span><br>
              <span class="animate-fade-in-right" style="animation-delay: 0.6s">des Bâtiments</span>
            </h1>
            
            <p class="text-xl text-gray-600 dark:text-gray-300 leading-relaxed animate-fade-in-up" style="animation-delay: 0.8s">
              Détection automatique des défauts structurels, prédiction des risques d'effondrement 
              et vérification de la conformité aux normes camerounaises grâce à l'IA et aux drones.
            </p>
            
            <div class="flex flex-col sm:flex-row gap-4 animate-fade-in-up" style="animation-delay: 1s">
              <button class="btn-primary hover-lift hover-glow group">
                <span class="mr-2">▶</span>
                Voir la Démo
                <div class="absolute inset-0 rounded-lg bg-white/20 scale-0 group-hover:scale-100 transition-transform duration-300"></div>
              </button>
              <button class="btn-ghost hover-tilt">
                <span class="mr-2">📄</span>
                Documentation
              </button>
            </div>

            <div class="flex items-center space-x-8 pt-4">
              <div class="text-center hover-scale animate-fade-in-up" style="animation-delay: 1.2s">
                <div class="text-2xl font-bold text-gradient animate-pulse-slow">90%+</div>
                <div class="text-sm text-gray-600 dark:text-gray-400">Précision IA</div>
              </div>
              <div class="text-center hover-scale animate-fade-in-up" style="animation-delay: 1.4s">
                <div class="text-2xl font-bold text-gradient animate-pulse-slow">50%</div>
                <div class="text-sm text-gray-600 dark:text-gray-400">Réduction Temps</div>
              </div>
              <div class="text-center hover-scale animate-fade-in-up" style="animation-delay: 1.6s">
                <div class="text-2xl font-bold text-gradient animate-pulse-slow">24/7</div>
                <div class="text-sm text-gray-600 dark:text-gray-400">Surveillance</div>
              </div>
            </div>
          </div>

          <div class="relative animate-fade-in-left">
            <div class="relative z-10 rounded-2xl shadow-2xl overflow-hidden hover-lift">
              <div class="animate-gradient w-full h-96 rounded-2xl flex items-center justify-center relative overflow-hidden">
                <div class="text-white opacity-30 text-8xl animate-float">🏢</div>
                <div class="absolute inset-0 animate-shimmer"></div>
              </div>
            </div>
            <div class="absolute -top-4 -right-4 w-72 h-72 bg-gradient-to-br from-emerald-400 to-teal-500 rounded-full opacity-20 blur-3xl animate-morphing"></div>
            <div class="absolute -bottom-8 -left-8 w-64 h-64 bg-gradient-to-br from-teal-400 to-emerald-500 rounded-full opacity-20 blur-3xl animate-morphing" style="animation-delay: 2s"></div>
          </div>
        </div>
      </div>
    </section>

    <hr class="dark:bg-gray-50 dark:text-gray-50 text-gray-800 bg-gray-800"/>

    <!-- Problem Statement -->
    <section class="py-16 bg-emerald-50 dark:bg-gray-800 relative overflow-hidden">
      <div class="absolute inset-0 animate-shimmer opacity-10"></div>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div class="text-center mb-12 animate-fade-in-down">
          <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-4 text-gradient">Problématique Actuelle</h2>
          <p class="text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto">
            Les méthodes traditionnelles d'inspection des bâtiments au Cameroun sont coûteuses, 
            lentes et sujettes aux erreurs humaines.
          </p>
        </div>

        <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          <div v-for="(problem, index) in problems" :key="index" 
               class="animate-fade-in-up card-hover hover-lift" 
               :style="`animation-delay: ${index * 200}ms`">
            <div class="text-center p-6 card-glass rounded-xl shadow-sm">
              <div class="w-12 h-12 bg-red-100 dark:bg-red-900 rounded-lg flex items-center justify-center mx-auto mb-4 animate-glow">
                <span class="text-red-600 dark:text-red-400 text-xl">{{ problem.emoji }}</span>
              </div>
              <h3 class="font-semibold text-gray-900 dark:text-white mb-2">{{ problem.title }}</h3>
              <p class="text-gray-600 dark:text-gray-300 text-sm">{{ problem.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="py-16 bg-emerald-50 dark:bg-gray-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16 animate-fade-in-down">
          <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-4 text-gradient">Fonctionnalités Principales</h2>
          <p class="text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto">
            Une solution complète combinant IA, drones et capteurs IoT pour une inspection automatisée et précise.
          </p>
        </div>

        <div class="grid lg:grid-cols-3 gap-8">
          <div v-for="(feature, index) in features" :key="index" 
               class="animate-scale-in hover-lift card-hover" 
               :style="`animation-delay: ${index * 300}ms`">
            <div class="p-8 border border-emerald-100 dark:border-emerald-800 rounded-2xl card-glass hover-glow">
              <div class="w-12 h-12 bg-emerald-100 dark:bg-emerald-900 rounded-lg flex items-center justify-center mb-6 animate-float">
                <span class="text-emerald-600 dark:text-emerald-400 text-xl">{{ feature.emoji }}</span>
              </div>
              <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-4">{{ feature.title }}</h3>
              <p class="text-gray-600 dark:text-gray-300 mb-6">{{ feature.description }}</p>
              <ul class="space-y-2 text-sm text-gray-600 dark:text-gray-400">
                <li v-for="(item, i) in feature.items" :key="i" class="flex items-center hover-scale">
                  <span class="text-emerald-500 mr-2">✓</span>
                  {{ item }}
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </section>

    <hr class="dark:bg-gray-50 dark:text-gray-50 text-gray-800 bg-gray-800"/>

    <!-- Technology Stack -->
    <section id="technology" class="py-16 bg-emerald-50 dark:bg-gray-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16 animate-fade-in-down">
          <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-4 text-gradient">Technologies Avancées</h2>
          <p class="text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto">
            Une pile technologique moderne combinant IA, drones et capteurs IoT pour des résultats optimaux.
          </p>
        </div>

        <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          <div v-for="(tech, index) in technologies" :key="index" 
               class="animate-bounce-in hover-tilt card-hover" 
               :style="`animation-delay: ${index * 200}ms`">
            <div class="text-center p-6 card-glass rounded-xl shadow-sm hover-glow">
              <div class="w-16 h-16 bg-emerald-100 dark:bg-emerald-900 rounded-full flex items-center justify-center mx-auto mb-4 animate-morphing">
                <span class="text-emerald-600 dark:text-emerald-400 text-2xl">{{ tech.emoji }}</span>
              </div>
              <h3 class="font-semibold text-gray-900 dark:text-white mb-2">{{ tech.title }}</h3>
              <p class="text-gray-600 dark:text-gray-300 text-sm mb-3">{{ tech.description }}</p>
              <div class="flex flex-wrap gap-1 justify-center">
                <span v-for="(tag, i) in tech.tags" :key="i" 
                      class="px-2 py-1 bg-emerald-100 dark:bg-emerald-900 text-emerald-800 dark:text-emerald-200 text-xs rounded hover-scale">
                  {{ tag }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Target Cities -->
    <section class="py-16 bg-emerald-50 dark:bg-gray-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12 animate-fade-in-down">
          <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-4 text-gradient">Zones Pilotes</h2>
          <p class="text-xl text-gray-600 dark:text-gray-300">
            Déploiement initial dans les zones à haut risque de Douala et Yaoundé
          </p>
        </div>

        <div class="grid md:grid-cols-2 gap-8">
          <div class="p-8 card-gradient rounded-2xl animate-fade-in-left card-hover hover-lift">
            <div class="flex items-center mb-6">
              <div class="w-12 h-12 bg-emerald-100 dark:bg-emerald-900 rounded-lg flex items-center justify-center mr-4 animate-glow">
                <span class="text-emerald-600 dark:text-emerald-400 text-xl">📍</span>
              </div>
              <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Douala</h3>
            </div>
            <p class="text-gray-600 dark:text-gray-300 mb-4">
              Quartiers prioritaires : New Bell, Bépanda et zones à forte densité urbaine.
            </p>
            <ul class="space-y-2 text-sm text-gray-600 dark:text-gray-400">
              <li class="flex items-center hover-scale">
                <span class="text-emerald-500 mr-2">✓</span>
                50 bâtiments pilotes
              </li>
              <li class="flex items-center hover-scale">
                <span class="text-emerald-500 mr-2">✓</span>
                Collaboration municipale
              </li>
              <li class="flex items-center hover-scale">
                <span class="text-emerald-500 mr-2">✓</span>
                Formation des équipes locales
              </li>
            </ul>
          </div>

          <div class="p-8 card-gradient rounded-2xl animate-fade-in-right card-hover hover-lift">
            <div class="flex items-center mb-6">
              <div class="w-12 h-12 bg-teal-100 dark:bg-teal-900 rounded-lg flex items-center justify-center mr-4 animate-glow">
                <span class="text-teal-600 dark:text-teal-400 text-xl">📍</span>
              </div>
              <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Yaoundé</h3>
            </div>
            <p class="text-gray-600 dark:text-gray-300 mb-4">
              Quartiers prioritaires : Manguier, Melen et zones de développement rapide.
            </p>
            <ul class="space-y-2 text-sm text-gray-600 dark:text-gray-400">
              <li class="flex items-center hover-scale">
                <span class="text-emerald-500 mr-2">✓</span>
                50 bâtiments pilotes
              </li>
              <li class="flex items-center hover-scale">
                <span class="text-emerald-500 mr-2">✓</span>
                Partenariat MINHDU
              </li>
              <li class="flex items-center hover-scale">
                <span class="text-emerald-500 mr-2">✓</span>
                Centre de formation technique
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <hr class="dark:bg-gray-50 dark:text-gray-50 text-gray-800 bg-gray-800"/>

    <!-- Timeline -->
    <section class="py-16 bg-emerald-50 dark:bg-gray-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12 animate-fade-in-down">
          <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-4 text-gradient">Calendrier du Projet</h2>
          <p class="text-xl text-gray-600 dark:text-gray-300">Déploiement sur 6 mois avec phases structurées</p>
        </div>

        <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div v-for="(timeline, index) in timelines" :key="index" 
               class="animate-slide-in-up hover-lift card-hover" 
               :style="`animation-delay: ${index * 200}ms`">
            <div class="p-6 card-glass rounded-xl shadow-sm hover-glow">
              <div class="text-center mb-4">
                <div :class="`w-12 h-12 ${timeline.color} rounded-full flex items-center justify-center mx-auto mb-2 animate-morphing`">
                  <span :class="`${timeline.textColor} font-bold`">{{ timeline.weeks }}</span>
                </div>
                <h3 class="font-semibold text-gray-900 dark:text-white">{{ timeline.title }}</h3>
              </div>
              <ul class="text-sm text-gray-600 dark:text-gray-400 space-y-1">
                <li v-for="(item, i) in timeline.items" :key="i" class="hover-scale">• {{ item }}</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="py-16 relative bg-emerald-50 dark:bg-gray-800 overflow-hidden">
      <div class="absolute inset-0 animate-shimmer opacity-20"></div>
      <div class="max-w-4xl mx-auto text-center px-4 sm:px-6 lg:px-8 relative z-10">
        <h2 class="text-3xl font-bold dark:text-white mb-4 animate-fade-in-up text-glow">
          Prêt à Révolutionner l'Inspection des Bâtiments ?
        </h2>
        <p class="text-xl dark:text-emerald-100 mb-8 animate-fade-in-up" style="animation-delay: 0.2s">
          Rejoignez le projet pilote et contribuez à la sécurité des infrastructures camerounaises.
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center animate-fade-in-up" style="animation-delay: 0.4s">
          <button class="btn-primary hover-lift hover-glow bg-white text-emerald-600 hover:bg-gray-100">
            <span class="mr-2">🚀</span>
            Participer au Projet
          </button>
          <button class="btn-ghost border-white text-white hover:bg-white/10">
            <span class="mr-2">📞</span>
            Nous Contacter
          </button>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer id="contact" class="bg-gray-900 text-white py-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid md:grid-cols-4 gap-8">
          <div class="col-span-2 animate-fade-in-up">
            <div class="flex items-center space-x-2 mb-4">
              <div class="h-8 w-8 text-emerald-400 animate-glow bg-gradient-to-br from-emerald-500 to-teal-600 rounded-lg flex items-center justify-center">
                <span class="text-white font-bold text-sm">BV</span>
              </div>
              <span class="text-xl font-bold text-gradient">Bâtiment Intelligent</span>
            </div>
            <p class="text-gray-400 mb-4">
              Système d'analyse écologique des bâtiments pour Douala et Yaoundé. 
              Détection automatique des défauts, prédiction des risques et vérification de conformité.
            </p>
            <div class="text-sm text-gray-500 animate-shimmer">
              Budget pilote : 20 millions FCFA | Durée : 6 mois
            </div>
          </div>

          <div class="animate-fade-in-up" style="animation-delay: 0.2s">
            <h3 class="font-semibold mb-4 text-gradient">Partenaires</h3>
            <ul class="space-y-2 text-gray-400">
              <li class="hover-scale">MINHDU</li>
              <li class="hover-scale">Municipalité Douala</li>
              <li class="hover-scale">Municipalité Yaoundé</li>
              <li class="hover-scale">École Polytechnique</li>
            </ul>
          </div>

          <div class="animate-fade-in-up" style="animation-delay: 0.4s">
            <h3 class="font-semibold mb-4 text-gradient">Contact</h3>
            <ul class="space-y-2 text-gray-400">
              <li class="flex items-center hover-scale">
                <span class="mr-2">✉️</span>
                contact@batiment-intelligent.cm
              </li>
              <li class="flex items-center hover-scale">
                <span class="mr-2">📞</span>
                +237 690 000 000
              </li>
              <li class="flex items-center hover-scale">
                <span class="mr-2">📍</span>
                Douala & Yaoundé, Cameroun
              </li>
            </ul>
          </div>
        </div>

        <div class="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400 animate-fade-in-up">
          <p>&copy; 2025 Bâtiment Intelligent. Tous droits réservés. | Produit le {{ currentDate }}</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { onMounted } from 'vue';

// Current date
const currentDate = new Date().toLocaleDateString('fr-FR', {
  day: 'numeric',
  month: 'long',
  year: 'numeric'
})

// Data with emojis for better visual appeal
const problems = [
  {
    emoji: '⚠️',
    title: 'Défauts Structurels',
    description: 'Fissures, corrosion et déformations non détectées'
  },
  {
    emoji: '⏰',
    title: 'Inspections Lentes',
    description: 'Processus manuels chronophages et coûteux'
  },
  {
    emoji: '🛡️',
    title: 'Non-Conformité',
    description: 'Manque de vérification des normes MINHDU'
  },
  {
    emoji: '📊',
    title: 'Données Limitées',
    description: 'Absence de bases de données centralisées'
  }
]

const features = [
  {
    emoji: '👁️',
    title: 'Détection Automatique',
    description: 'Identification des fissures, corrosion et déformations grâce à la vision par ordinateur et aux modèles CNN/YOLO.',
    items: [
      'Précision > 90%',
      'Analyse en temps réel'
    ]
  },
  {
    emoji: '📈',
    title: 'Prédiction des Risques',
    description: 'Modèles ML pour prédire les risques d\'effondrement basés sur les données des capteurs IoT.',
    items: [
      'Capteurs MPU-6050, DHT22, FC-28',
      'Alertes automatiques'
    ]
  },
  {
    emoji: '✅',
    title: 'Vérification Conformité',
    description: 'Contrôle automatique de la conformité aux normes de construction camerounaises (MINHDU).',
    items: [
      'Normes MINHDU',
      'Rapports exportables'
    ]
  }
]

const technologies = [
  {
    emoji: '🧠',
    title: 'Intelligence Artificielle',
    description: 'CNN, YOLO, Random Forest, XGBoost',
    tags: ['TensorFlow', 'PyTorch']
  },
  {
    emoji: '🚁',
    title: 'Drones',
    description: 'DJI Mavic 3 avec caméras 4K',
    tags: ['DJI SDK', 'Pix4D']
  },
  {
    emoji: '📡',
    title: 'Capteurs IoT',
    description: 'MPU-6050, DHT22, FC-28',
    tags: ['ESP32', 'MQTT']
  },
  {
    emoji: '🌐',
    title: 'Plateforme Web',
    description: 'Interface responsive multilingue',
    tags: ['React', 'Python']
  }
]

const timelines = [
  {
    weeks: '1-2',
    title: 'R&D',
    color: 'bg-emerald-100 dark:bg-emerald-900',
    textColor: 'text-emerald-600 dark:text-emerald-400',
    items: [
      'Analyse des besoins',
      'Collecte de données',
      'Développement IA'
    ]
  },
  {
    weeks: '3-4',
    title: 'Prototypage',
    color: 'bg-teal-100 dark:bg-teal-900',
    textColor: 'text-teal-600 dark:text-teal-400',
    items: [
      'Acquisition matériel',
      'Développement backend',
      'Tests sur 10 bâtiments'
    ]
  },
  {
    weeks: '5',
    title: 'Tests',
    color: 'bg-green-100 dark:bg-green-900',
    textColor: 'text-green-600 dark:text-green-400',
    items: [
      'Tests terrain',
      '100 bâtiments pilotes',
      'Retours utilisateurs'
    ]
  },
  {
    weeks: '6',
    title: 'Déploiement',
    color: 'bg-cyan-100 dark:bg-cyan-900',
    textColor: 'text-cyan-600 dark:text-cyan-400',
    items: [
      'Déploiement complet',
      'Formation équipes',
      'Rapport final'
    ]
  }
]

// Router simulation
const router = {
  push: (path) => {
    console.log(`Navigating to: ${path}`)
  }
}

// Smooth scrolling and animations
onMounted(() => {
  // Smooth scrolling for navigation links
  const links = document.querySelectorAll('a[href^="#"]')
  links.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault()
      const target = document.querySelector(link.getAttribute('href'))
      if (target) {
        target.scrollIntoView({ behavior: 'smooth' })
      }
    })
  })
  
  // Intersection Observer for scroll animations
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('active')
      }
    })
  }, { threshold: 0.1 })

  // Observe all animated elements
  document.querySelectorAll('.animate-on-scroll').forEach(el => {
    observer.observe(el)
  })

  // Add parallax effect
  window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset
    const parallax = document.querySelectorAll('.parallax')
    const speed = 0.5

    parallax.forEach(element => {
      const yPos = -(scrolled * speed)
      element.style.transform = `translateY(${yPos}px)`
    })
  })
})

const { getCurrentUser } = useAuth();
let user = computed(() => getCurrentUser());
</script>
