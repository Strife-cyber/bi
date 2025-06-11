<template>
  <header class="fixed w-full z-50">
    <!-- Glassmorphism -->
    <div class="glass-effect bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg border-b border-emerald-100/80 dark:border-emerald-800/50 shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
          <!-- Logo -->
          <NuxtLink 
            to="/" 
            class="flex-shrink-0 flex items-center space-x-3 hover:scale-[1.02] transition-transform duration-200 group"
            aria-label="Go to homepage"
          >
            <div class="w-10 h-10 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-xl flex items-center justify-center shadow-md group-hover:shadow-lg group-hover:shadow-emerald-500/20 transition-shadow">
              <span class="text-white font-bold text-lg select-none">BI</span>
            </div>
            <div class="hidden sm:block">
              <span class="text-xl font-bold text-gradient bg-gradient-to-r from-emerald-600 to-teal-600 bg-clip-text text-transparent">
                Bâtiment Intelligent
              </span>
              <div class="text-xs text-gray-500 dark:text-gray-400 font-medium mt-0.5">
                Inspection IA • Cameroun
              </div>
            </div>
          </NuxtLink>

          <!-- Navigation (Desktop) -->
          <nav 
            class="hidden lg:flex lg:ml-8 lg:space-x-1"
            aria-label="Main navigation"
          >
            <div 
              v-for="item in navItems" 
              :key="item.name"
            >
              <NuxtLink
                :to="item.path"
                class="relative inline-flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-all duration-200 group"
                :class="{
                  'bg-emerald-50/80 dark:bg-emerald-900/50 text-emerald-700 dark:text-emerald-300': $route.path === item.path,
                  'text-gray-700 dark:text-gray-300 hover:bg-gray-100/50 dark:hover:bg-gray-800/50': $route.path !== item.path,
                }"
                :aria-current="$route.path === item.path ? 'page' : undefined"
              >
                <UIcon 
                  :name="item.icon" 
                  class="h-4 w-4 mr-2" 
                  aria-hidden="true"
                />
                <span>{{ item.name }}</span>
                <div 
                  v-if="$route.path === item.path"
                  class="absolute -bottom-1 left-1/2 transform -translate-x-1/2 w-4 h-0.5 bg-emerald-500 rounded-full"
                ></div>
              </NuxtLink>
            </div>
          </nav>

          <!-- Right: Actions (Desktop) -->
          <div class="hidden md:flex md:items-center md:space-x-2">
            <!-- Notifications -->
            <UButton
              variant="ghost"
              size="md"
              color="gray"
              class="px-2.5 relative mx-4"
              aria-label="Notifications"
            >
              <UIcon name="i-heroicons-bell" class="h-16 w-16 dark:text-white text-black" />
              <UBadge 
                v-if="unreadNotifications > 0"
                color="red" 
                variant="solid" 
                size="xs"
                class="absolute -top-1 -right-1 dark:text-white text-black"
              >
                {{ unreadNotifications }}
              </UBadge>
            </UButton>

            <UDropdownMenu
              :items="userMenuItems"
              :content="{
                align: 'start',
                side: 'bottom',
                sideOffset: 8,
                class: 'bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl shadow-lg p-2 space-y-1 animate-fade-in'
              }"
            >
              <!-- Dropdown Button -->
              <UButton
                variant="ghost"
                size="md"
                color="gray"
                class="px-2.5 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-300 rounded-full"
                aria-label="User menu"
              >
                <div class="flex items-center gap-2">
                  <span class="truncate w-[150px] font-semibold text-gray-800 dark:text-gray-200 hidden lg:inline overflow-hidden whitespace-nowrap">
                    {{ user?.displayName }}
                  </span>
                  <UAvatar 
                    :src="user?.photoURL" 
                    :alt="user?.displayName"
                    size="md"
                    :ui="{ size: { xs: 'h-8 w-8 text-md' } }"
                    class="ring-2 ring-gray-300 p-1 dark:text-white  dark:ring-gray-600"
                  />
                  <UIcon 
                    name="i-heroicons-chevron-down" 
                    class="h-5 w-5 text-gray-500 dark:text-gray-400 transition-transform group-hover:rotate-180"
                  />
                </div>
              </UButton>

              <!-- Dropdown Item Template -->
              <template #item="{ item, active }">
                <div
                  class="flex w-full items-center px-3 py-2 rounded-lg cursor-pointer transition-colors duration-200 hover:bg-gray-100 dark:hover:bg-gray-700"
                  :class="{ 'bg-gray-100 dark:bg-gray-700': active }"
                >
                  <UIcon 
                    :name="item.icon" 
                    class="h-5 w-5 mr-3 text-gray-500 dark:text-gray-400"
                  />
                  <span class="text-sm text-gray-700 dark:text-gray-200">
                    {{ item.label }}
                  </span>
                </div>
              </template>
            </UDropdownMenu>
          </div>

          <!-- Mobile Menu Button -->
          <UButton
            @click="toggleMobileMenu"
            variant="ghost"
            size="xl"
            color="gray"
            class="md:hidden px-2.5 dark:text-white cursor-pointer"
            :aria-label="isMobileMenuOpen ? 'Close menu' : 'Open menu'"
            :aria-expanded="isMobileMenuOpen"
          >
            <UIcon 
              :name="isMobileMenuOpen ? 'i-heroicons-x-mark' : 'i-heroicons-bars-3'" 
              class="h-32 w-32" 
            />
          </UButton>
        </div>
      </div>

      <!-- Mobile Menu -->
      <Transition
        enter-active-class="transition-all duration-200 ease-out"
        enter-from-class="opacity-0 -translate-y-4"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition-all duration-150 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-4"
      >
        <div 
          v-if="isMobileMenuOpen"
          class="md:hidden"
          @keydown.esc="closeMobileMenu"
          ref="mobileMenu"
        >
          <div class="px-4 pt-2 pb-6 space-y-2 bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg border-t border-gray-200/50 dark:border-gray-700/50">
            <!-- Mobile Navigation -->
            <div class="space-y-1">
              <NuxtLink
                v-for="item in navItems" 
                :key="item.name"
                :to="item.path"
                @click="closeMobileMenu"
                class="flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors duration-200"
                :class="{
                  'bg-emerald-50/80 dark:bg-emerald-900/50 text-emerald-700 dark:text-emerald-300': $route.path === item.path,
                  'text-gray-700 dark:text-gray-300 hover:bg-gray-100/50 dark:hover:bg-gray-800/50': $route.path !== item.path,
                }"
                :aria-current="$route.path === item.path ? 'page' : undefined"
              >
                <UIcon 
                  :name="item.icon" 
                  class="h-5 w-5 mr-3" 
                />
                {{ item.name }}
              </NuxtLink>
            </div>

            <!-- Mobile Actions -->
            <div class="pt-4 border-t border-gray-200/50 dark:border-gray-700/50 space-y-1">
              <NuxtLink
                to="/notifications"
                @click="closeMobileMenu"
                class="flex items-center px-4 py-3 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100/50 dark:hover:bg-gray-800/50 rounded-lg transition-colors duration-200"
              >
                <UIcon name="i-heroicons-bell" class="h-5 w-5 mr-3" />
                Notifications
                <UBadge 
                  v-if="unreadNotifications > 0"
                  color="red" 
                  variant="solid" 
                  size="xs"
                  class="ml-auto"
                >
                  {{ unreadNotifications }}
                </UBadge>
              </NuxtLink>

              <NuxtLink
                to="/profile"
                @click="closeMobileMenu"
                class="flex items-center px-4 py-3 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100/50 dark:hover:bg-gray-800/50 rounded-lg transition-colors duration-200"
              >
                <UIcon name="i-heroicons-user" class="h-5 w-5 mr-3" />
                My Profile
              </NuxtLink>

              <NuxtLink
                to="/settings"
                @click="closeMobileMenu"
                class="flex items-center px-4 py-3 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100/50 dark:hover:bg-gray-800/50 rounded-lg transition-colors duration-200"
              >
                <UIcon name="i-heroicons-cog-6-tooth" class="h-5 w-5 mr-3" />
                Settings
              </NuxtLink>

              <UButton
                @click="handleLogout"
                variant="ghost"
                color="red"
                class="w-full justify-start px-4 py-3"
              >
                <UIcon name="i-heroicons-arrow-right-on-rectangle" class="h-5 w-5 mr-3" />
                Logout
              </UButton>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </header>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue';
import { useRoute } from 'vue-router';

const isOffline = ref(false);
const isMobileMenuOpen = ref(false);
const unreadNotifications = ref(0);
const allUnreadNotifications = ref([]);
const route = useRoute();
const mobileMenu = ref(null);

const { user, logout } = useAuth();
const { initialize, fetchNotifications } = useNotifications();

const navItems = [
  { name: 'Dashboard', path: '/dashboard', icon: 'i-heroicons-home' },
  { name: 'Inspections', path: '/inspections', icon: 'i-heroicons-building-office' },
  { name: 'Reports', path: '/reports', icon: 'i-heroicons-document-text' },
  { name: 'Predictions', path: '/predictions', icon: 'i-heroicons-shield-exclamation' },
];

const userMenuItems = computed(() => [
  [
    { label: 'My Profile', icon: 'i-heroicons-user', to: '/profile', click: closeMobileMenu },
    { label: 'Settings', icon: 'i-heroicons-cog-6-tooth', to: '/settings', click: closeMobileMenu },
  ],
  [
    { label: 'Help & Support', icon: 'i-heroicons-question-mark-circle', to: '/help', click: closeMobileMenu },
    { label: 'Documentation', icon: 'i-heroicons-book-open', to: '/docs', click: closeMobileMenu },
  ],
  [
    { label: 'Logout', icon: 'i-heroicons-arrow-right-on-rectangle', click: handleLogout },
  ],
]);

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value;
  if (isMobileMenuOpen.value) {
    nextTick(() => {
      const firstFocusable = mobileMenu.value?.querySelector('a, button');
      firstFocusable?.focus();
    });
  }
};

const closeMobileMenu = () => {
  isMobileMenuOpen.value = false;
};

const handleLogout = async () => {
  console.log('logging out');
  await logout();
  closeMobileMenu();
  navigateTo('/');
};

watch(() => route.path, closeMobileMenu);

const handleClickOutside = (event) => {
  if (isMobileMenuOpen.value && !event.target.closest('header')) {
    closeMobileMenu();
  }
};

const handleKeydown = (event) => {
  if (event.key === 'Escape' && isMobileMenuOpen.value) {
    closeMobileMenu();
  }
};

const handleFocusTrap = (event) => {
  if (!isMobileMenuOpen.value || !mobileMenu.value) return;
  const focusableElements = mobileMenu.value.querySelectorAll(
    'a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])',
  );
  if (focusableElements.length === 0) return;
  const firstElement = focusableElements[0];
  const lastElement = focusableElements[focusableElements.length - 1];
  if (event.target === firstElement && event.shiftKey) {
    event.preventDefault();
    lastElement.focus();
  } else if (event.target === lastElement && !event.shiftKey) {
    event.preventDefault();
    firstElement.focus();
  }
};

watch(user, (newUser) => {
  initialize(newUser.uid);
})

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
  document.addEventListener('keydown', handleKeydown);
  document.addEventListener('keydown', handleFocusTrap);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
  document.removeEventListener('keydown', handleKeydown);
  document.removeEventListener('keydown', handleFocusTrap);
});
</script>

<style scoped>
.glass-effect {
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
}

.text-gradient {
  background: linear-gradient(135deg, #10b981, #059669);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

a, button {
  transition: color 0.15s ease, background-color 0.15s ease, transform 0.15s ease, box-shadow 0.15s ease;
}

:focus-visible {
  outline: 2px solid #10b981;
  outline-offset: 2px;
}

@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
</style>