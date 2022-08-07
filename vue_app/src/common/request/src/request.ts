/**
 *  @desc 封装axios请求
 */
import axios from 'axios';

export default class Request {
    // 从js移植过来后需增加这些声明
    axiosObj: any;
    config: object;
    cancelToken;
    requesthooks: [];
    responsehooks: [];

    constructor(config: any) {
        this.axiosObj = axios.create(this.initConfig(config));
        this.config = config;
        this.cancelToken = axios.CancelToken;
        this.axiosObj.CancelToken = axios.CancelToken;
        // this.initInterceptorsHook()
        this.requesthooks = [];
        this.responsehooks = [];
        this.processRequestHook(config.reqHooks); // 传入的方法名
        this.processResponseHook(config.resHooks); // 传入的方法名
    }

    //默认配置
    initConfig(config: any): any {
        return {
            method: 'post',
            timeout: config.timeout || 30000
        };
    }

    //初始化拦截
    initInterceptorsHook() {
        this.requesthooks = [];
        this.responsehooks = [];
    }

    //处理请求拦截
    processRequestHook(cb: any) {
        if (typeof cb === 'function') {
            cb(this.requesthooks);
        }
        // 添加请求拦截器
        this.axiosObj.interceptors.request.use(
            (config: any) => {
                return this.requesthooks.reduce((prePromise, { resolve }) => {
                    return prePromise.then(resolve);
                }, Promise.resolve(config));
            },
            (error: any) => {
                return this.requesthooks.reduce((prePromise, { reject }) => {
                    return prePromise.catch(reject);
                }, Promise.reject(error));
            }
        );
    }

    //处理响应拦截
    processResponseHook(cb: any) {
        if (typeof cb === 'function') {
            cb(this.responsehooks);
        }
        // 添加响应拦截器
        this.axiosObj.interceptors.response.use(
            (config: any) => {
                return this.responsehooks.reduce((prePromise, { resolve }) => {
                    return prePromise.then(resolve);
                }, Promise.resolve(config));
            },
            (error: any) => {
                return this.responsehooks.reduce((prePromise, { reject }) => {
                    return prePromise.catch(reject);
                }, Promise.reject(error));
            }
        );
    }

}
