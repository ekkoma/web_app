import { createRouter, createWebHashHistory } from 'vue-router';


const routes = [
    {
        // 根页
        path: '/',
        redirect: '/login',
        component: () => import('@/views/portal.vue'),
        children: [
        ],
    },
    {
        // 首页
        path: '/portal',
        component: () => import('@/views/portal.vue'),
        children: [

        ],
    },
    {
        // 示例页
        path: '/hello',
        component: () => import('@/views/HelloWorld.vue')
    },
    {
        path: '/about',
        component: () => import('@/views/about.vue')
    },
    {
        path: '/menu',
        component: () => import('@/views/menu.vue')
    },
    {
        path: '/login',
        component: () => import('@/views/login/login.vue')
    },
    {
        path: '/links',
        component: () => import('@/views/links.vue')
    },
]

const router = createRouter({
    history: createWebHashHistory(),
    routes,
});

console.log("enter route defs, route count:" + routes.length)

export default router;
