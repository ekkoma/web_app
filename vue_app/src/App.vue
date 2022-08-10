<template>
  <!-- loading框 -->
  <IxSpin class="app__loading" :spinning="isLoading">
    <!-- 提示框 -->
    <IxMessageProvider ref="message">
      <router-view />
    </IxMessageProvider>
  </IxSpin>
</template>

<script setup lang="ts">
import useMessageStore from '@/common/store/message';
import useLoadingStore from '@/common/store/loading';
import { storeToRefs } from 'pinia';

let messageStore = useMessageStore();
let loadingStore = useLoadingStore();

//保存提示框实例
let { message } = storeToRefs(messageStore);

//记录loading状态
let { isLoading } = storeToRefs(loadingStore);

// console.log("enter App.vue, message:" + JSON.stringify(message) + ", isloading:" + JSON.stringify(isLoading))
</script>

<style scoped>
.app__loading,
.ix-spin-container {
  flex: 1;
  display: flex;
  flex-direction: column;
}
</style>
