import { defineStore } from 'pinia';
import { CACHE_KEY } from '@/common/const/my_const';
import { storage } from '@/common/utils/utils';
import API from '@/common/api/my_app';

const useUserStore = defineStore('user', {
    state: () => {
        return {
            name: storage.getItem('userName') || 'name',
            id: storage.getItem(CACHE_KEY.USER_ID) || '0'
        };
    },
    actions: {
        //设置用户名称
        setName(name: string) {
            storage.setItem('userName', name);
            this.name = name;
        },
        //设置用户工号
        setID(id: string) {
            storage.setItem(CACHE_KEY.USER_ID, id);
            this.id = id;
        },

        //登录接口
        login(formData: any) {
            return API.login(formData).then(({  }) => {
                this.setID(formData.id);
                this.setName(formData.name);
                console.log("data:" + '')
                // 设置登录状态
            });
        },
    },
    getters: {
        // avatarURL(state) {
        //   return createAvatar(state.id)
        // }
    }
});

export default useUserStore;
