<template>
    <div id="myapp" class="demo">
        <p>查看日期类别</p>

        <div id="role">
            1. 请选择角色
            <select id="select_role" @input="onSelect">
                <option value="1">ZP</option>
                <option value="2">GWL</option>
            </select>
        </div>

        <div id="date">
            2. 请选择日期
            <input id="input_date" type="date" @input="onSelect" />
        </div>

        <div id="div_area">
            <textarea id="area" readonly>等待计算...</textarea>
        </div>

        <div id="version">
            <p>version 1.0 20220827</p>
        </div>

    </div>

</template>

<script setup lang="ts">

// 1-工作日，2-单休，3-双休，4-法定节假日，5-加班日
let checkDate = (dateStr: any) => {
    // 获取角色
    let role = 'ZP';
    let oListBox = document.getElementById("select_role") as HTMLSelectElement
    if (oListBox) {
        role = oListBox.options[oListBox.options.selectedIndex].text
    }

    console.log('role:' + role + ', selected date:' + dateStr)

    // 节假日日期
    let arrHolidays = [
        20220101, 20220102, 20220103,
        20220131, 20220201, 20220202, 20220203, 20220204, 20220205, 20220206,
        20220403, 20220404, 20220405,
        20220430, 20220501, 20220502, 20220503, 20220504,
        20220603, 20220604, 20220605,
        20220910, 20220911, 20220912,
        20221001, 20221002, 20221003, 20221004, 20221005, 20221006, 20221007
    ]
    let tmpIndex = arrHolidays.indexOf(Number(dateStr.replace(/-/g, "")));
    if (tmpIndex !== -1) {
        return 4
    }

    let tmpDate = dateStr + " 00:00:00"
    let oDate = new Date(Date.parse(tmpDate.replace(/-/g, "/")));
    let day = oDate.getDay()
    if (role === 'GWL') {
        // 0-周日，6-周六
        if ((day === 0) || (day === 6)) {
            return 3
        }
    } else if (role === 'ZP') {
        let oBaseDate: any
        if (day === 6) {
            // 双休base日期
            oBaseDate = new Date('2022/08/27 00:00:00')
        }
        else if (day === 0) {
            // 双休base日期
            oBaseDate = new Date('2022/08/28 00:00:00')
        }

        if ((day === 0) || (day === 6)) {
            let diff = Math.abs(oBaseDate.getTime() - oDate.getTime()) / 1000 / 86400;
            console.log('base date:' + oBaseDate + ', base timestamp:' + oBaseDate.getTime() + ', diff:' + diff)
            if ((diff % 2) != 0) {
                if (day === 6) {
                    return 5
                }
                return 2
            }

            return 3
        }
    }

    // 其他为工作日
    return 1
};

let onSelect = () => {
    let dateStr = ""
    let oDateCtl = document.getElementById("input_date") as HTMLInputElement
    if (oDateCtl) {
        dateStr = oDateCtl.value;
    }

    if (dateStr === "") {
        console.log('no date selected')
        return;
    }

    let result = ""
    switch (checkDate(dateStr)) {
        case 1:
            result = "ALL RIGHT， " + dateStr + " 是工作日。";
            break;
        case 2:
            result = "GOOD！ " + dateStr + " 是单休！";
            break;
        case 3:
            result = "NICE！ " + dateStr + " 是双休！";
            break;
        case 4:
            result = "YEAH！ " + dateStr + " 是法定节假日！";
            break;
        case 5: 
            result = "ALL RIGHT， " + dateStr + " 是加班日。";
            break;
        default:
            result = "ALL RIGHT， " + dateStr + " 是工作日。";
            break;
    }

    let oAreaCtl = document.getElementById("area")
    if (oAreaCtl) {
        oAreaCtl.innerHTML = result
    }
};

</script>

<style>
#myapp {
    font-size: 50px;
    text-align: center;
    margin-top: 150px;
}

#role {
    font-size: 20px;
    text-align: center
}

#date {
    font-size: 20px;
}

#div_area {
    margin-top: 25px;
}

#area {
    font-size: 15px;
    font-family: 'Times New Roman', Times, serif;
    width: 300px;
    height: 90px;
}

#version {
    margin-top: 10px;
    font-size: 10px;
}
</style>
