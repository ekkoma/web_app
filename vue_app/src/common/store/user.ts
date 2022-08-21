import { defineStore } from 'pinia';
import { storage } from '@/common/utils/utils';
import API from '@/common/api/my_app';

const useUserStore = defineStore('user', {
    state: () => {
        return {
            user: storage.getItem('userName') || '',
        };
    },
    actions: {
        //设置用户名称
        setName(name: string) {
            storage.setItem('userName', name);
            this.user = name;
        },

        //登录接口
        login(formData: any) {
            return API.login(formData).then(({ }) => {
                storage.removeItem('userName')
                this.setName(formData.user);
                // 设置登录状态
            });
        },
        userName() {
            return this.user;
        }
    },
    getters: {
        // avatarURL(state) {
        //   return createAvatar(state.id)
        // }
        
    }
});

export default useUserStore;
