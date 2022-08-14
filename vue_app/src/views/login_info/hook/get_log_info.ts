import API from '@/common/api/my_app';
import { ref } from 'vue';

const resultList: any = ref([]);

export default function getLoginInfo() {
    API.loginfo().then((result: any) => {
        // console.log("get login info success:" + JSON.stringify(result))
        let tmpList = []
        for (let [index, item] of result.data.entries()) {
            tmpList.push({
                'key': index + 1, // 必须指定该字段，不然控制台报错
                'index': index + 1,
                'insert_time': item.insert_time,
                'login_user': item.login_user,
                'client_addr': item.client_addr,
                'client_port': item.client_port,
            })
        }

        resultList.value = tmpList
    }).catch((err: any) => {
        console.log("get login info failed:" + JSON.stringify(err))
    });

    return resultList
}
