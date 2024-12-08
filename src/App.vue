<template>
  <header class="navbar">
    <div class="navbar-start text-xl"><h1 class="pl-3">Lens Adapter Generator</h1></div>
    <div class="navbar-end pr-3">
      <ul class="menu menu-horizontal bg-base-200 rounded-box">
        <!-- <li v-for="link in navLinks" :key="link.path">
          <RouterLink :to="link.path" active-class="active">
            <component :is="link.meta.icon" class="inline-block w-5 h-5" />
            {{ link.meta.nav }}
          </RouterLink>
        </li> -->
      </ul>
    </div>
  </header>

  <main class="container mx-auto mt-5">
    <RouterView />
  </main>

  <footer class="footer p-5 mt-auto">
    <aside>
      <p>
        Made with love by
        <a class="link link-primary" target="_blank" href="https://privatebutts.dev"
          >Private Butts</a
        >.
      </p>
    </aside>
    <aside class="ms-auto">
      <p>
        <a
          href="https://github.com/PrivateButts/lens-adapter-generator/issues"
          target="_blank"
          class="link link-primary"
          >Report an issue</a
        >&nbsp;|&nbsp;
        <a
          class="link link-primary"
          target="_blank"
          href="https://github.com/PrivateButts/lens-adapter-generator"
          >View source</a
        >
      </p>
    </aside>
  </footer>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { RouterLink, RouterView, useRouter } from 'vue-router'

const router = useRouter()

const navLinks = computed(() => {
  return router.getRoutes().filter((route) => route.meta.nav)
})
</script>

<style scoped>
header {
  line-height: 1.5;
  max-height: 100vh;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

nav {
  width: 100%;
  font-size: 12px;
  text-align: center;
  margin-top: 2rem;
}

nav a.router-link-exact-active {
  color: var(--color-text);
}

nav a.router-link-exact-active:hover {
  background-color: transparent;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  border-left: 1px solid var(--color-border);
}

nav a:first-of-type {
  border: 0;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }

  nav {
    text-align: left;
    margin-left: -1rem;
    font-size: 1rem;

    padding: 1rem 0;
    margin-top: 1rem;
  }
}
</style>
