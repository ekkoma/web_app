import request from '@/common/request/req_imp'; // 来自这个里边的默认导出，导入时名称可以任意命名

// 这个导出被导入时可以任意命名，例如API
export default {
    //登录
    login(data: {}) {
        return request({
            url: "/login",
            method: "post",
            loading: true,
            data,
        });
    },
};
