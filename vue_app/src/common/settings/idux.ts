import type { App } from 'vue';

import IduxCdk from '@idux/cdk';
import IduxComponents from '@idux/components';
import IduxPro from '@idux/pro';

// https://idux.site/docs/getting-started/zh

// 如果不需要 reset 全局样式和滚动条样式，移除下面 2 行代码
// import "@idux/components/style/core/reset.default.css";
// import "@idux/components/style/core/reset-scroll.default.css";

// 如果需要 css 按需加载，移除下面 2 行代码
import '@idux/components/default.min.css';
import '@idux/pro/default.min.css';

// 默认为中文，可以打开注释设置为其他语言
// import { useLocale, enUS } from "@idux/components/i18n";
// useLocale(enUS);

import { createGlobalConfig } from '@idux/components/config';
import {
  IDUX_ICON_DEPENDENCIES,
  addIconDefinitions,
} from '@idux/components/icon';

// 静态加载: `IDUX_ICON_DEPENDENCIES` 是 `@idux` 的部分组件默认所使用到图标，建议在此时静态引入。
addIconDefinitions(IDUX_ICON_DEPENDENCIES);

// 动态加载：不会被打包，可以减小包体积，需要加载的时候时候 http 请求加载
const loadIconDynamically = async (iconName: string) => {
  const res = await fetch(`/idux-icons/${iconName}.svg`);
  return await res.text();
};

const globalConfig = createGlobalConfig({
  icon: { loadIconDynamically },
});

const install = (app: App): void => {
  app.use(IduxCdk).use(IduxComponents).use(IduxPro).use(globalConfig);
};

export default { install };
