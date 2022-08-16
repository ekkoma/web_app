import { createRouter, createWebHashHistory, createWebHistory } from 'vue-router';
import { storage } from '@/common/utils/utils';

const routes = [
    {
        // 根页
        path: '/',
        name: 'root-page',
        redirect: '/login', // 访问根自动重定向到登录页
        component: () => import('@/views/portal.vue'),
        children: [
        ],
    },
    {
        // 首页
        path: '/portal',
        name: 'portal-page',
        component: () => import('@/views/portal.vue'),
        children: [

        ],
    },
    {
        // 示例页
        path: '/hello',
        name: 'hello-page',
        component: () => import('@/views/HelloWorld.vue')
    },
    {
        path: '/about',
        name: 'about-page',
        component: () => import('@/views/about.vue')
    },
    {
        path: '/menu',
        name: 'menu-page',
        component: () => import('@/views/menu.vue')
    },
    {
        path: '/login',
        name: 'login-page',
        component: () => import('@/views/login/login.vue')
    },
    {
        path: '/links',
        name: 'links-page',
        component: () => import('@/views/links.vue')
    },
    {
        path: '/loginfo',
        name: 'loginfo-page',
        component: () => import('@/views/login_info/loginfo.vue')
    },
]

const router = createRouter({
    history: createWebHashHistory(), // 带#号的url
    // history: createWebHistory(), // 不带#号的url
    routes,
});

console.log("enter route defs, route count:" + routes.length)

router.beforeEach(async (to: any, from: any) => {
    let userName = storage.getItem('userName')
    console.log("from.name:" + from.name + ", to.name:" + to.name + ", user.name:" + userName)

    // 未登录成功访问其他路由页时，自动重定向到登录页
    if ((to.name !== 'login-page') && (userName === '')) {
        return { name: 'login-page' }
    }
})

export default router;
