import { defineAsyncComponent } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/voron'
    },
    {
      path: '/voron',
      name: 'voron',
      meta: {
        title: 'Voron Serial Plate Generator',
        nav: 'Voron',
        icon: defineAsyncComponent(() => import('@/assets/voron.svg')),
        theme: 'voron'
      },
      component: () => import('@/views/VoronGenerator.vue')
    },
    {
      path: '/jm',
      name: 'journeymaker',
      meta: {
        title: 'JourneyMaker Serial Plate Generator',
        // nav: 'JourneyMaker',
        icon: defineAsyncComponent(() => import('@/assets/journeymaker.svg')),
        theme: 'journeymaker'
      },
      component: () => import('@/views/JourneyMakerGenerator.vue')
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
