//处理localStorage缓存
export default class Storage {
    // ts里成员变量必须有前置声明
    prefix;

    constructor(option: any) {
        this.prefix = option.prefix
    }

    //根据key获取缓存，不存在返回默认值
    getItem(key: string, defaultValue: string = '') {
        const value = localStorage.getItem(this.formatKey(key));
        if (value) {
            return JSON.parse(value);
        }
        return defaultValue;
    }

    //设置缓存
    setItem(key: string, value = {}) {
        localStorage.setItem(this.formatKey(key), JSON.stringify(value));
    }

    //删除缓存
    removeItem(key: string) {
        localStorage.removeItem(this.formatKey(key));
    }

    formatKey(key: string) {
        if (this.prefix) {
            return this.prefix.call(this, key)
        }
        return key
    }
}
