import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import './main.css'
import App from './App.vue'

// Routes
import Home from './pages/Home.vue'

const routes = [
  { path: '/', component: Home },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

const app = createApp(App)

app.config.globalProperties.$log = console.log

app.use(router)

app.mount('#app')
