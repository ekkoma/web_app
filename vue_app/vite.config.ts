import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "src")
    }
  },
  plugins: [vue()],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          // echarts: ['echarts']
          
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
      }
    }
  },

})

