import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

import { IduxResolver } from 'unplugin-vue-components/resolvers'
import Components from 'unplugin-vue-components/vite'

import { visualizer } from 'rollup-plugin-visualizer'
const lifecycle = process.env.npm_lifecycle_event

// https://vitejs.dev/config/
export default defineConfig({
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "src")
    }
  },
  plugins: [
    vue(),
    Components({
      resolvers: [IduxResolver()],
      // 可以通过指定 `importStyle` 来按需加载 css 或 less 代码
      // 别忘了移除掉 idux.ts 中的样式导入代码
      // resolvers: [IduxResolver({ importStyle: 'css' })],
    }),
    lifecycle === 'report' ? visualizer({ open: true, brotliSize: true, filename: 'report.html' }) : null,
  ],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          // echarts: ['echarts'],
          // Idux: ['Idux'],
          // lodash: ['lodash'],
        }
      }
    }
  },

  server: {
    // host: '0.0.0.0',
    proxy: {
      '/api/motto': {
        target: 'http://47.106.162.19/',
        changeOrigin: true,
      },
      '/api/login_info': {
        target: 'http://47.106.162.19/',
        // target: 'http://127.0.0.1:12345/',
        changeOrigin: true,
      },
      '/login': {
        target: 'http://47.106.162.19/',
        // target: 'http://127.0.0.1:12345/',
        changeOrigin: true,
      },
    }
  },

})

