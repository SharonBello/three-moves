import { defineConfig, type UserConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'node:path';

const config: UserConfig = {
  plugins: [react()],
  base: '/',
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  css: {
    preprocessorOptions: {
      scss: {
        api: 'modern',
        additionalData: '@use "@/styles/_tokens.scss" as *; @use "@/styles/_mixins.scss" as *;',
      },
    },
  },
};

export default defineConfig(config);