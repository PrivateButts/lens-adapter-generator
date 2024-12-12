import { defineAsyncComponent } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/lens'
    },
    {
      path: '/lens',
      name: 'lens',
      meta: {
        title: 'Lens Adapter Generator',
        nav: 'Lens Mount',
        icon: defineAsyncComponent(() => import('@/assets/voron.svg')),
        theme: 'voron'
      },
      component: () => import('@/views/LensGenerator.vue')
    }
  ]
})

router.beforeEach((to, from, next) => {
  if (to.meta.theme) {
    document.documentElement.setAttribute('data-theme', to.meta.theme as string)
  } else {
    document.documentElement.setAttribute('data-theme', 'dark')
  }
  next()
})

router.afterEach((to, from, failure) => {
  if (to.meta.title) {
    document.title = to.meta.title as string
  }
})

export default router
