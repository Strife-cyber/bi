export default defineNuxtRouteMiddleware((to) => {
  if (process.server) return

  const user = useCookie('user')

  const isPublic = /^\/(login|register|auth(\/|$)|$)/.test(to.path)

  if (!isPublic && !user.value) {
    return navigateTo('/auth/login')
  }
})
