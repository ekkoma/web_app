<template>
    <section class="login">
        <IxInput v-model:value="loginFormData.user" class="login__input" placeholder="账号" type="text" />
        <IxInput v-model:value="loginFormData.password" class="login__input" placeholder="密码" :type="showPassword ? 'text' : 'password'" >
            <template #suffix>
                <IxIcon :name="showPassword ? 'eye' : 'eye-invisible'" @click="onSuffixClick" />
            </template>
        </IxInput>

        <button class="login__button" type="button" :disabled="btnDisabled" @click="onLogin">
            登录
        </button>
    </section>

    <div class="motto" id="motto001">
        
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import useLogin from '@/views/login/hook/user_login';
import API from '@/common/api/my_app';

let { onLogin, loginFormData, btnDisabled } = useLogin();

const showPassword = ref(false)
const onSuffixClick = () => {
    showPassword.value = !showPassword.value
}

//获取格言
API.motto().then((result: any) => {
    let motto = document.getElementById("motto001")
    if (motto) {
        motto.innerHTML = result.data
    }
    console.log("get motto success:" + JSON.stringify(result))
}).catch((err: any) => {
    console.log("get motto failed:" + err)
});

console.log("enter login.vue, form data:" + JSON.stringify(loginFormData) + ", button disabled:" + Object.keys(btnDisabled))
</script>

<style>
.login {
    display: flex;
    flex-direction: column;
    width: 320px;
    margin: 0 auto;
}

.login__input {
    height: 44px;
    /* text-align: center; */
    margin-bottom: 16px;
    /* border-radius: 4px; */
}

/* .login__input::placeholder {
    color: #728199;
    text-align: center;
} */

.login__button {
    width: 320px;
    height: 44px;
    color: #4c4c4c;
    font-weight: bold;
    background-color: #ffdf26;
    border-radius: 4px;
}

.login__button:active {
    background-color: #699f2e;
}

.login__button:disabled {
    background-color: #41403b;
}

.motto {
    margin-top: 30px;
    text-align: center;
    font-family: sans-serif, Verdana, Geneva, Tahoma;
    font-size: 25px;
    color: rgb(100, 122, 218);
}

</style>
