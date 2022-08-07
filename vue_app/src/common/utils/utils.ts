// import createAvatar from './create_avatar';
import Storage from '@/common/utils/storage';
import { CACHE_KEY } from '@/common/const/my_const';

export const storage = new Storage({
    prefix: function (key: string) {  //缓存前缀
        if (key !== CACHE_KEY.USER_ID) {
            const curUserID = this.getItem(CACHE_KEY.USER_ID) || '0'
            key = curUserID + '_' + key
        }
        return key
    }
});

// export { createAvatar }

export function sleep(time = 1000) {
    return new Promise((r: any) => {
        setTimeout(() => {
            r();
        }, time);
    });
}

//记录是否转换过
const timeMap: any = {};
//转换秒的格式
export function formatTime(time: number, format: string) {
    let map
    if (format) {
        map = timeMap[format] = (timeMap[format] || {})
    } else {
        map = timeMap
    }
    if (map[time]) {
        return map[time];
    }
    let r = ''
    const m = String(Math.floor(time / 60)).padStart(2, '0')
    const s = String(Math.floor(time % 60)).padStart(2, '0')
    if (format) {
        r = [m, s].join(format)
    } else {
        if (Number(m) > 0) {
            r = `${m}m${s}s`
        } else {
            r = `${s}s`
        }
    }
    return (map[time] = r);
}

export function isFunction(func: {}) {
    return typeof func === 'function'
}

export function isUndefined(val: {}) {
    return typeof val === 'undefined'
}
