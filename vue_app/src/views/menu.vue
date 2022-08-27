<template>
    <h1 id="title01">欢迎使用菜单</h1>

    <div id="div01">
        1. 尝试使用按钮
        <button onclick="alert('嘿嘿嘿')">点我</button>
    </div>

    <div id="div02">
        2. 尝试使用链接
        <router-link to="/assist">
            <span id="assist-link">小助手</span>
        </router-link>
    </div>

</template>

<script setup lang="ts">

console.log("enter menu.vue");

</script>

<style>
#title01 {
    margin-top: 1px;
    margin-bottom: 100px;
    font-family: '仿宋', 'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande', 'Lucida Sans Unicode', Geneva, Verdana, sans-serif;
}

#div02 {
    margin-top: 20px;
}

#assist-link {
    font-size: 20px;
}
</style>
