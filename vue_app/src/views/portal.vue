<template>
    <div id="list">
        <router-link to="/menu"><p>菜单</p></router-link>
        <router-link to="/hello"><p>示例</p></router-link>
        <router-link to="/about"><p>关于</p></router-link>
        <router-link to="/links"><p>友链</p></router-link>
    </div>

    <div class="c_loginfo">
        <button id="button001" @click="enterLoginfo">查看日志</button>
    </div>

</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';

console.log("enter portal.vue")

const router = useRouter();
let enterLoginfo = () => {
    router.push('/loginfo')
}

</script>

<style scoped>
#list {
    font-size: 2em;
    flex: 1;
    padding-top: 0px;
    /* background-image: url("@/assets/image/bg.png"); */
    background-size: 100%; 
}

.c_loginfo {
    margin-top: 20px;
}

</style>
