<template>
    <div id="list">
        <router-link to="/menu"><p>菜单</p></router-link>
        <router-link to="/hello"><p>示例</p></router-link>
        <router-link to="/about"><p>关于</p></router-link>
        <router-link to="/links"><p>友链</p></router-link>
    </div>

</template>

<script setup lang="ts">
    console.log("enter portal.vue")

</script>

<style scoped>
#list {
    font-size: 2em;
    flex: 1;
    padding-top: 0px;
    /* background-image: url("@/assets/image/bg.png"); */
    background-size: 100%; 
}
</style>
