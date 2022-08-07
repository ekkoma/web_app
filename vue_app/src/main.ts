import '@/assets/style.css' // 全局样式
import App from '@/App.vue' // 主页面
import router from '@/router/route_defs' // js
import Idux from '@/common/settings/idux'; // js

import { createApp } from 'vue'
import { createPinia } from 'pinia';

console.log("app create before")

const app = createApp(App)

app.use(createPinia());
app.use(router)
app.use(Idux);

app.mount('#app')

console.log("app mount done")
