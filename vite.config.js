import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'node:path';
var config = {
    plugins: [react()],
    base: '/',
    resolve: {
        alias: {
            '@': path.resolve(__dirname, './src'),
        },
    },
    build: {
        rollupOptions: {
            output: {
                hashCharacters: 'hex',
                entryFileNames: 'assets/[name]-[hash].js',
                chunkFileNames: 'assets/[name]-[hash].js',
                assetFileNames: 'assets/[name]-[hash][extname]',
            },
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
