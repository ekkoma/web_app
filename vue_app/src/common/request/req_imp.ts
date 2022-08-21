import Request from '@/common/request/src/request';
import useLoadingStore from '@/common/store/loading';
import useMessageStore from '@/common/store/message';
import { sleep } from '@/common/utils/utils';

const messageStore = useMessageStore();

let loadingCount = 0 //记录loading弹出次数
const loadingStore = useLoadingStore();

const { axiosObj } = new Request({

    //请求拦截方法
    reqHooks(request: any) {
        //处理loading
        request.push({
            resolve(config: any) {
                if (config.loading === true && 0 === loadingCount++) {
                    loadingStore.loading()
                }
                return Promise.resolve(config);
            },
            reject(err: any) {
                return Promise.reject(err);
            },
        })
    },

    //响应拦截方法
    resHooks(response: any) {
        //处理loading
        response.push({
            resolve(res: any) {
                if (res.config.loading === true && 0 === Math.max(--loadingCount, 0)) {
                    loadingStore.close()
                }
                return Promise.resolve(res);
            },
            reject(error: any) {
                if (error.config.loading === true && 0 === Math.max(--loadingCount, 0)) {
                    loadingStore.close()
                }
                return Promise.reject(error);
            },
        });

        //处理接口返回数据
        response.push({
            resolve(res: any) {
                const data = res.data;
                if (data.code === 0) {
                    return data;
                }
                if (data.code === 2) {
                    messageStore.error('当前账号已过期')
                    setTimeout(() => {
                        location.replace('/')
                    }, 1000);
                    return
                }
                if (data.polling === true) {//自定义属性，当返回数据有这属性时，重新调用接口
                    return sleep(data.pollingTime || 1000).then(() => axiosObj(res.config))
                }
                messageStore.error(data.msg);
                return Promise.reject(data);
            },
            async reject(error: any) {
                const err = {
                    msg: error.message || error,
                };
                if (err.msg === 'Network Error' && error.config) {
                    await sleep(500);
                    return axiosObj(error.config);
                }
                messageStore.error(err.msg);
                return Promise.reject(err);
            },
        });
    },
});

export default axiosObj;
