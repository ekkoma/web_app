import { defineStore } from 'pinia';

//提示框API
const useMessageStore = defineStore('message', {
  state: () => {
    return {
      message: null
    };
  },
  actions: {
    //错误框
    error(msg: string) {
      if (this.message) {
        // this.message.error(msg) // 这个用ts编译不过
        console.log("err msg:" + msg)
      }
    },
    //成功框
    success(msg: string) {
      if (this.message) {
        // this.message.success(msg)
        console.log("succ msg:" + msg)
      }
    }
  },
});

export default useMessageStore;
