import { defineStore } from 'pinia';

//Loading框API
const useLoadingStore = defineStore('loading', {
  state: () => {
    return {
      isLoading: false
    };
  },
  actions: {
    //设置loading框
    setLoading(isLoading: boolean) {
      this.isLoading = isLoading
    },
    //打开loading框
    loading() {
      this.setLoading(true)
    },
    //关闭loading框
    close() {
      this.setLoading(false)
    }
  },
});

export default useLoadingStore;
