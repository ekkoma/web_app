<template>
    <IxTable class="table001" :columns="columns" :dataSource="dataContent">
        <template #name="{ value }">
            <a>{{ value }}</a>
        </template>
    </IxTable>
</template>

<script setup lang="ts">
import { IxTable } from "@idux/components/table";

import getLoginInfo from '@/views/login_info/hook/get_log_info';
import { TableColumn } from '@idux/components/table';

interface LoginInfo {
    key: number
    insert_time: string
    login_user: string
    client_addr: string
    client_port: number
    // request_hearders: string
}

const columns: TableColumn<LoginInfo>[] = [
    {
        title: '序号',
        dataKey: 'index',
        customCell: 'index',
    },
    {
        title: '登录时间',
        dataKey: 'insert_time',
    },
    {
        title: '用户名',
        dataKey: 'login_user',
    },
    {
        title: 'IP',
        dataKey: 'client_addr',
        // customCell: 'client_addr',
    },
    {
        title: '端口',
        dataKey: 'client_port',
        // customCell: 'client_port',
    },
];

let dataContent: LoginInfo[] = getLoginInfo();

</script>


<style scoped lang="less">
#info001 {
    margin-top: 10px;
}

.table001 {
    :deep(.even-row) td {
        background-color: #fafafa;
    }

    :deep(.odd-row) td {
        background-color: rgba(141, 132, 132, 0.544);
    }
}
</style>
