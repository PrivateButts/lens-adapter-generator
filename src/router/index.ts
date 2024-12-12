import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

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
        title: 'Voron Serial Plate Generator'
      },
      component: () => import('../views/VoronGenerator.vue')
    },
    {
      path: '/jm',
      name: 'journeymaker',
      meta: {
        title: 'JourneyMaker Serial Plate Generator'
      },
      component: () => import('../views/JourneyMakerGenerator.vue')
    }
  ]
})

router.afterEach((to, from, failure) => {
  if (to.meta.title) {
    document.title = to.meta.title as string
  }
})

export default router
