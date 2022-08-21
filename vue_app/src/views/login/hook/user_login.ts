import { useRouter } from 'vue-router';
import { computed, reactive } from 'vue';
import useUserStore from '@/common/store/user';
import useMessageStore from '@/common/store/message';

//获取当前用户状态
const userStore = useUserStore();
const messageStore = useMessageStore();

export default function useLogin() {
    const router = useRouter();
    //姓名和工号
    const loginFormData = reactive({
        user: '',
        password: '',
    });

    //姓名或工号为空时，登录按钮不可用
    const btnDisabled = computed(() => {
        const name = loginFormData.user.trim();
        const id = loginFormData.password.trim();
        return name === '' || id === '';
    });

    //登录
    async function onLogin() {
        try {
            const user = loginFormData.user.trim();
            const password = loginFormData.password.trim();
            await userStore.login({ user, password });
            // TODO 根据登录状态，来切换相应路由
            // const route = await gameStore.getRuningRoute();
            const route: any = await new Promise(
                (resolve, reject) => {
                    return resolve('/portal')
                }
            );
            console.log("login success, user:" + user);
            messageStore.success("欢迎你：" + user);

            router.push(route);
        } catch (err) {
            // messageStore.error("噢出错了请排查");
            console.log(err, 'login err');
        }
    }
    return { onLogin, loginFormData, btnDisabled };
}
