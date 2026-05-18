import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'node:path';
export default defineConfig({
    plugins: [react()],
    resolve: {
        alias: { '@': path.resolve(__dirname, './src') },
    },
    css: {
        preprocessorOptions: {
            scss: {
                api: 'modern',
                additionalData: "@use \"@/styles/_tokens.scss\" as *; @use \"@/styles/_mixins.scss\" as *;",
            },
        },
    },
});
