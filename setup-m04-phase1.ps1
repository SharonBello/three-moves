# ════════════════════════════════════════════════════════════════
# setup-m04-phase1.ps1
# M04 · Three Moves · Phase 1 — full scaffold + Section 1 (Opening)
#
# RUN FROM: an empty folder where the M04 project should live, e.g.
#   C:\Users\sharo\OneDrive\Documents\sharon_workspace\three-moves\
#
# (Do NOT run from inside the M03 folder.)
#
# After this PS1 finishes:
#   PS> npm install
#   PS> npm run dev
# ════════════════════════════════════════════════════════════════

function W ($p, $c) {
    $full = Join-Path (Get-Location) $p
    $dir  = Split-Path $full -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "  + $p" -ForegroundColor Green
}

# Safety: don't overwrite a project that exists at this location
if (Test-Path 'package.json') {
    $confirm = Read-Host "package.json already exists here. Overwrite? (y/N)"
    if ($confirm -ne 'y') { Write-Host "Aborted." -ForegroundColor Red; exit 1 }
}

Write-Host ""
Write-Host "Scaffolding M04 Phase 1..." -ForegroundColor Cyan
Write-Host ""

W 'package.json' @'
{
  "name": "m04-three-moves",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.26.2",
    "react-icons": "^5.3.0"
  },
  "devDependencies": {
    "@types/node": "^20.16.0",
    "@types/react": "^18.3.5",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.1",
    "sass": "^1.78.0",
    "typescript": "^5.5.3",
    "vite": "^5.4.8"
  }
}
'@

W 'vite.config.ts' @'
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
        additionalData: `@use "@/styles/_tokens.scss" as *; @use "@/styles/_mixins.scss" as *;`,
      },
    },
  },
});
'@

W 'tsconfig.json' @'
{
  "compilerOptions": {
    "target": "ES2022",
    "useDefineForClassFields": true,
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": { "@/*": ["src/*"] }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
'@

W 'tsconfig.node.json' @'
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "types": ["node"]
  },
  "include": ["vite.config.ts"]
}
'@

W 'index.html' @'
<!doctype html>
<html lang="he" dir="rtl">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#C9B79A" />

    <!-- Fonts: Caveat (handwritten Latin) + Suez One (Hebrew display) + Assistant (Hebrew body) + IBM Plex Mono -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Assistant:wght@400;500;700&family=Caveat:wght@400;600;700&family=IBM+Plex+Mono:wght@400;500&family=Suez+One&display=swap"
      rel="stylesheet"
    />

    <title>M04 · שלושה מהלכים בשיעור חינוך</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
'@

W '.gitignore' @'
node_modules
dist
dist-ssr
*.local
.vite
.DS_Store
*.log
.env
.env.*
!.env.example
'@

W 'README.md' @'
# M04 · שלושה מהלכים בשיעור חינוך

Three-hour AI training module for Israeli homeroom teachers (מחנכים/ות).
The teacher walks away with 4 PDF lesson plans — three demo lessons co-built through the workshop (one per age tier: יסודי, חט״ב, תיכון) plus one personal lesson for their actual class.

## The three moves

1. **מחולל תרחישים** — Scenario Generator (best for יסודי)
2. **שלוש קולות** — Three Voices: teacher / student / parent (best for חט״ב)
3. **מהמקרה אל הערך** — Backwards from a real case (best for תיכון)

## Stack

Vite · React 18 · TypeScript · SCSS (modern API) · React Router (hash) · `localStorage` for state.

## Develop

```bash
npm install
npm run dev      # http://localhost:5173
npm run build    # tsc -b && vite build
npm run preview  # serve dist locally
```

## Deploy

Cloudflare Pages — same setup as M03 (`m03-pedagogical-spoiler`). Build cmd `npm run build`, output `dist`, env `NODE_VERSION=20`.
'@

W 'public/favicon.svg' @'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <rect width="64" height="64" rx="12" fill="#C9B79A"/>
  <g transform="rotate(-30 32 32)">
    <rect x="22" y="14" width="20" height="36" rx="2" fill="#F4D55A"/>
    <rect x="22" y="14" width="20" height="6" fill="#E8C547"/>
    <polygon points="22,50 42,50 32,60" fill="#2C3E50"/>
    <polygon points="28,56 36,56 32,60" fill="#1A2A38"/>
  </g>
</svg>
'@

W 'src/main.tsx' @'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './styles/global.scss';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
'@

W 'src/App.tsx' @'
import React from 'react';
import ModuleRouter from './router/ModuleRouter';

const App: React.FC = () => <ModuleRouter />;

export default App;
'@

W 'src/vite-env.d.ts' @'
/// <reference types="vite/client" />
'@

W 'src/styles/_tokens.scss' @'
// ═══════════════════════════════════════════════════════════════════
// M04 · Sketchbook Design Tokens
// Notebook / paper aesthetic — warm, human, hand-made.
// Distinct from M03's cold blueprint grid.
// ═══════════════════════════════════════════════════════════════════

// ── PAPER & INK ────────────────────────────────────────────────
$paper-kraft:       #C9B79A;   // main bg — kraft paper
$paper-kraft-dark:  #B19F80;
$paper-cream:       #FAF6E8;   // "white paper" cards
$paper-cream-2:     #F5EFD9;   // sticky note variant
$paper-line:        rgba(44, 62, 80, 0.12);  // notebook ruled lines

// Ink (pen)
$ink-blue:          #2C3E50;   // primary text
$ink-blue-dark:     #1A2A38;   // headings
$ink-blue-soft:     #4A5A6A;   // muted body

// Pencil
$pencil:            #555555;
$pencil-light:      #999999;

// Marker (signature accent, same as M03 for module-family identity)
$red-pen:           #C44536;
$red-pen-dark:      #8E2C20;
$red-pen-pale:      #FAE0DC;

// Highlighter (warm yellow)
$highlight:         #F4D55A;
$highlight-dark:    #C9A91D;
$highlight-pale:    #FBEBC2;

// Washi tape
$tape-washi:        #A8C8DA;   // blue washi
$tape-washi-dark:   #6F9AB0;
$tape-kraft:        #D7B080;   // kraft tape
$sticky-kraft:      #E8D4B5;   // pale kraft, for sticky-note variant

// Status
$success:           #4A8F3F;
$success-pale:      #DDEFDA;
$danger:            $red-pen;
$warning:           #D89234;

$white:             #FFFFFF;

// ── TYPOGRAPHY ─────────────────────────────────────────────────
$font-display:    'Suez One', 'Assistant', serif;       // Hebrew display
$font-script:     'Caveat', cursive;                    // Latin handwritten accents
$font-body:       'Assistant', system-ui, sans-serif;
$font-mono:       'IBM Plex Mono', monospace;

$weight-normal:   400;
$weight-medium:   500;
$weight-bold:     700;
$weight-black:    900;

$text-xs:         11px;
$text-sm:         13px;
$text-base:       15px;
$text-md:         16px;
$text-lg:         19px;
$text-xl:         24px;
$text-2xl:        32px;
$text-3xl:        42px;

$leading-tight:   1.2;
$leading-body:    1.55;
$leading-loose:   1.7;

// ── SPACING / SIZING ───────────────────────────────────────────
$space-1: 4px;
$space-2: 8px;
$space-3: 12px;
$space-4: 16px;
$space-5: 24px;
$space-6: 32px;
$space-7: 48px;
$space-8: 64px;

$radius-sm: 4px;
$radius-md: 8px;
$radius-lg: 12px;
$radius-xl: 20px;
$radius-full: 999px;

// Shadows — softer, paper-feel
$shadow-paper:  0 1px 2px rgba(44, 62, 80, 0.06), 0 2px 4px rgba(44, 62, 80, 0.04);
$shadow-lift:   0 2px 6px rgba(44, 62, 80, 0.1), 0 4px 12px rgba(44, 62, 80, 0.06);
$shadow-tape:   0 1px 2px rgba(0, 0, 0, 0.08);
$shadow-sticky: 2px 4px 8px rgba(0, 0, 0, 0.08);

// Motion
$dur-fast:      150ms;
$dur-base:      250ms;
$ease-out:      cubic-bezier(0.2, 0.8, 0.2, 1);

// Breakpoints
$bp-sm: 480px;
$bp-md: 768px;
$bp-lg: 1024px;
$bp-xl: 1200px;

// Borders
$border-dash:   1px dashed $paper-line;
$border-pencil: 1.5px solid $ink-blue-soft;

// Z-index
$z-base:    1;
$z-raised:  10;
$z-overlay: 100;
$z-modal:   1000;

// ── CSS CUSTOM PROPERTIES (for runtime theming) ────────────────
:root {
  --c-paper-kraft:    #{$paper-kraft};
  --c-paper-cream:    #{$paper-cream};
  --c-paper-cream-2:  #{$paper-cream-2};
  --c-ink-blue:       #{$ink-blue};
  --c-ink-blue-dark:  #{$ink-blue-dark};
  --c-ink-blue-soft:  #{$ink-blue-soft};
  --c-red-pen:        #{$red-pen};
  --c-red-pen-pale:   #{$red-pen-pale};
  --c-highlight:      #{$highlight};
  --c-highlight-pale: #{$highlight-pale};
  --c-tape-washi:     #{$tape-washi};
  --c-tape-kraft:     #{$tape-kraft};
}
'@

W 'src/styles/_mixins.scss' @'
// ═══════════════════════════════════════════════════════════════════
// M04 · Sketchbook Mixins
// The reusable "motifs" of the notebook aesthetic.
// ═══════════════════════════════════════════════════════════════════
@use "tokens" as *;

// ── LAYOUT ─────────────────────────────────────────────────────
@mixin flex-col   { display: flex; flex-direction: column; }
@mixin flex-row   { display: flex; flex-direction: row; }
@mixin flex-center  { display: flex; align-items: center; justify-content: center; }
@mixin flex-between { display: flex; align-items: center; justify-content: space-between; }
@mixin flex-start   { display: flex; align-items: center; }

@mixin respond-to($bp) {
  @if $bp == sm { @media (min-width: $bp-sm) { @content; } }
  @else if $bp == md { @media (min-width: $bp-md) { @content; } }
  @else if $bp == lg { @media (min-width: $bp-lg) { @content; } }
  @else if $bp == xl { @media (min-width: $bp-xl) { @content; } }
}

// ── ACCESSIBILITY ──────────────────────────────────────────────
@mixin focus-ring {
  &:focus-visible {
    outline: 2px solid $red-pen;
    outline-offset: 3px;
  }
}

@mixin sr-only {
  position: absolute;
  width: 1px; height: 1px;
  padding: 0; margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

// ═══════════════════════════════════════════════════════════════
// SKETCHBOOK MOTIFS
// ═══════════════════════════════════════════════════════════════

// Paper grain — subtle dot texture overlay
@mixin paper-grain {
  background-image:
    radial-gradient(circle at 25% 25%, rgba(44, 62, 80, 0.028) 0.5px, transparent 1.5px),
    radial-gradient(circle at 75% 75%, rgba(44, 62, 80, 0.02) 0.5px, transparent 1px);
  background-size: 28px 28px, 36px 36px;
  background-position: 0 0, 14px 18px;
}

// Notebook ruled lines — faint horizontals at consistent rhythm
@mixin ruled-paper($line-color: $paper-line, $line-height: 32px) {
  background-image: linear-gradient(
    to bottom,
    transparent calc(#{$line-height} - 1px),
    #{$line-color} calc(#{$line-height} - 1px),
    #{$line-color} #{$line-height},
    transparent #{$line-height}
  );
  background-size: 100% #{$line-height};
}

// Plain paper card — white-ish surface on kraft bg
@mixin paper-card {
  background: $paper-cream;
  border-radius: $radius-md;
  box-shadow: $shadow-paper;
  position: relative;
}

// Taped card — paper card with washi tape strips at top corners
@mixin taped-card($tape-color: $tape-washi) {
  @include paper-card;
  padding: $space-6 $space-5 $space-5;

  &::before, &::after {
    content: '';
    position: absolute;
    top: -10px;
    width: 64px;
    height: 22px;
    background: rgba(168, 200, 218, 0.78);
    box-shadow: $shadow-tape;
    border-radius: 1px;
    z-index: 2;
  }
  &::before { inset-inline-start: 14%; transform: rotate(-3deg); }
  &::after  { inset-inline-end:   14%; transform: rotate(2.5deg); }
}

// Sticky note — slight rotation, warm yellow bg, soft shadow
@mixin sticky-note($bg: $highlight-pale, $rotation: -1.5deg) {
  background: $bg;
  padding: $space-4 $space-5;
  transform: rotate($rotation);
  box-shadow: $shadow-sticky;
  position: relative;
  font-family: $font-body;
  border-radius: 2px;  // tiny rounding, not bookish
}

// Pen underline — solid red line under text
@mixin pen-underline($color: $red-pen, $thickness: 3px) {
  background-image: linear-gradient(to right, $color 0%, $color 100%);
  background-position: 0 95%;
  background-repeat: no-repeat;
  background-size: 100% $thickness;
  padding-bottom: 4px;
}

// Highlighter swipe — soft yellow background behind inline text
@mixin highlighter($color: $highlight) {
  background: linear-gradient(
    to bottom,
    transparent 0%,
    transparent 40%,
    $color 40%,
    $color 92%,
    transparent 92%,
    transparent 100%
  );
  padding: 0 4px;
}

// Pencil border — soft, low-key border
@mixin pencil-border($color: $ink-blue-soft, $width: 1.5px) {
  border: $width solid $color;
  border-radius: $radius-md;
}

// Margin note — small handwritten-ish note in the side margin
@mixin margin-note {
  font-family: $font-script;
  font-size: 18px;
  color: $red-pen;
  transform: rotate(-2deg);
  display: inline-block;
}
'@

W 'src/styles/global.scss' @'
// ═══════════════════════════════════════════════════════════════════
// M04 · Global Styles
// ═══════════════════════════════════════════════════════════════════

*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html { scroll-behavior: smooth; }

body {
  font-family: $font-body;
  font-size: $text-base;
  line-height: $leading-body;
  color: $ink-blue;
  background: $paper-kraft;
  @include paper-grain;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
  min-height: 100vh;
  direction: rtl;
}

// ── TYPOGRAPHY DEFAULTS ───────────────────────────────────────
h1, h2, h3, h4, h5, h6 {
  font-family: $font-display;
  font-weight: $weight-bold;
  line-height: $leading-tight;
  color: $ink-blue-dark;
  letter-spacing: -0.01em;
}

p { line-height: $leading-body; }

a {
  color: $red-pen;
  text-decoration: none;

  &:hover { text-decoration: underline; }
}

button {
  font-family: inherit;
  font-size: inherit;
  cursor: pointer;
}

// ── REDUCED MOTION ─────────────────────────────────────────────
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}

// ═══════════════════════════════════════════════════════════════════
// PRINT STYLES (used by Section 8's LessonPlanCanvas for PDF export)
// ═══════════════════════════════════════════════════════════════════
@page {
  size: A4;
  margin: 20mm 18mm;
}

@media print {
  body {
    background: white !important;
    background-image: none !important;
    color: black !important;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }

  body * { visibility: hidden !important; }
  .m04-print, .m04-print * { visibility: visible !important; }
  .m04-print {
    position: absolute;
    inset-inline-start: 0;
    top: 0;
    width: 100%;
    padding: 0 !important;
    margin: 0 !important;
    box-shadow: none !important;
    border: none !important;
  }

  .m04-print-field {
    page-break-inside: avoid;
    break-inside: avoid;
  }

  a[href]::after { content: '' !important; }
}
'@

W 'src/types/module.types.ts' @'
// ═══════════════════════════════════════════════════════════════════
// M04 · Module Types
// 8 sections; each move pairs with one age tier.
// ═══════════════════════════════════════════════════════════════════

export type SectionId =
  | 'opening'    // 1 · the prep problem
  | 'theory'     // 2 · the 3 moves at a glance
  | 'scenarios'  // 3 · Move 1 (Scenario Generator) → יסודי demo
  | 'break'      // 4 · pick YOUR class for the personal lesson
  | 'voices'     // 5 · Move 2 (Three Voices) → חט"ב demo
  | 'case'       // 6 · Move 3 (Backwards from Case) → תיכון demo
  | 'personal'   // 7 · the teacher's own lesson
  | 'closing';   // 8 · 4 PDFs + final commitment

export type MoveKey = 'scenarios' | 'voices' | 'case';

export type AgeTier = 'elementary' | 'middle' | 'high';

export interface Section {
  id: SectionId;
  number: number;       // 1..8
  title: string;
  subtitle: string;
  durationMin: number;
  path: string;         // hash route e.g. '/scenarios'
}

export interface SectionState {
  id: SectionId;
  visited: boolean;
  completed: boolean;
}

// What the teacher entered in the Break section — for the personal lesson
export interface CustomTopic {
  subject: string;     // e.g. "חינוך"
  grade: string;       // e.g. "ז'"
  ageTier: AgeTier;    // elementary | middle | high
  topic: string;       // e.g. "תקרית בבוקר עם הקבוצה של שני"
  context?: string;    // optional notes about the class
}

export interface ModuleProgress {
  moduleId: 'm04';
  sections: Record<SectionId, SectionState>;
  completedAt: number | null;
  customTopic: CustomTopic | null;
  quizScore: number | null;
  /** Which move did the teacher pick for the personal lesson? */
  personalMove: MoveKey | null;
}
'@

W 'src/types/lesson.types.ts' @'
// ═══════════════════════════════════════════════════════════════════
// M04 · Lesson Types
// The 4 PDFs the teacher leaves with:
//   3 demo lessons (one per age tier, co-built through workshop)
//   1 personal lesson (their own class)
// ═══════════════════════════════════════════════════════════════════

import type { MoveKey, AgeTier } from './module.types';

export interface LessonPlanFields {
  /** Auto-filled */
  subject: string;       // מקצוע
  grade: string;         // כיתה
  topic: string;         // נושא
  duration: string;      // משך — usually "45 דק'"
  /** Free-form by teacher */
  goals: string;         // מטרות
  openingHook: string;   // פתיח (Engage)
  body: string;          // גוף השיעור
  discussion: string;    // דיון / שאלות מנחות
  closure: string;       // סיכום
  takeaway: string;      // מה לוקחים הביתה
}

/** Which "move" was used to generate this lesson — drives the PDF subtitle */
export interface LessonPlan extends LessonPlanFields {
  generatedBy: MoveKey;
  ageTier: AgeTier;
}
'@

W 'src/data/sections.ts' @'
// ═══════════════════════════════════════════════════════════════════
// M04 · Sections Data
// Order, titles, durations, route paths.
// ═══════════════════════════════════════════════════════════════════
import type { Section, SectionId } from '@/types/module.types';

export const SECTIONS: Section[] = [
  { id: 'opening',   number: 1, title: 'פתיחה',     subtitle: 'השיעור הכי משמעותי. הכנה מהירה',           durationMin: 15, path: '/opening' },
  { id: 'theory',    number: 2, title: 'תיאוריה',   subtitle: 'שלושה מהלכים · מבט מהיר',            durationMin: 20, path: '/theory' },
  { id: 'scenarios', number: 3, title: 'מהלך 1',    subtitle: 'מחולל תרחישים · יסודי',              durationMin: 25, path: '/scenarios' },
  { id: 'break',     number: 4, title: 'הפסקה',     subtitle: 'בחירת הכיתה שלך',                    durationMin: 15, path: '/break' },
  { id: 'voices',    number: 5, title: 'מהלך 2',    subtitle: 'שלוש קולות · חט״ב',                  durationMin: 25, path: '/voices' },
  { id: 'case',      number: 6, title: 'מהלך 3',    subtitle: 'מהמקרה אל הערך · תיכון',             durationMin: 25, path: '/case' },
  { id: 'personal',  number: 7, title: 'השיעור שלך', subtitle: 'מהלך אחד · הכיתה שלך',              durationMin: 30, path: '/personal' },
  { id: 'closing',   number: 8, title: 'סיכום',     subtitle: '4 שיעורים · קח לכיתה',               durationMin: 25, path: '/closing' },
];

export const SECTION_BY_ID: Record<SectionId, Section> = SECTIONS.reduce(
  (acc, s) => { acc[s.id] = s; return acc; },
  {} as Record<SectionId, Section>,
);

export const TOTAL_DURATION_MIN = SECTIONS.reduce((sum, s) => sum + s.durationMin, 0);
'@

W 'src/hooks/useModuleProgress.ts' @'
// ═══════════════════════════════════════════════════════════════════
// useModuleProgress — single source of truth for the teacher's
// progress through M04. Persists to localStorage.
// ═══════════════════════════════════════════════════════════════════
import { useCallback, useEffect, useState } from 'react';
import { SECTIONS } from '@/data/sections';
import type {
  ModuleProgress,
  SectionId,
  CustomTopic,
  MoveKey,
} from '@/types/module.types';

const STORAGE_KEY = 'binai.m04.progress.v1';

function emptyProgress(): ModuleProgress {
  const sections = SECTIONS.reduce(
    (acc, s) => { acc[s.id] = { id: s.id, visited: false, completed: false }; return acc; },
    {} as ModuleProgress['sections'],
  );
  return {
    moduleId: 'm04',
    sections,
    completedAt: null,
    customTopic: null,
    quizScore: null,
    personalMove: null,
  };
}

function load(): ModuleProgress {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return emptyProgress();
    const parsed = JSON.parse(raw) as ModuleProgress;
    // Merge with empty in case schema gained new fields
    return { ...emptyProgress(), ...parsed,
      sections: { ...emptyProgress().sections, ...(parsed.sections ?? {}) }
    };
  } catch { return emptyProgress(); }
}

function save(p: ModuleProgress) {
  try { localStorage.setItem(STORAGE_KEY, JSON.stringify(p)); } catch { /* quota / private */ }
}

export function useModuleProgress() {
  const [progress, setProgress] = useState<ModuleProgress>(load);

  useEffect(() => { save(progress); }, [progress]);

  const visit = useCallback((id: SectionId) => {
    setProgress(p => ({
      ...p,
      sections: { ...p.sections, [id]: { ...p.sections[id], visited: true } },
    }));
  }, []);

  const complete = useCallback((id: SectionId) => {
    setProgress(p => ({
      ...p,
      sections: { ...p.sections, [id]: { ...p.sections[id], visited: true, completed: true } },
      completedAt: id === 'closing' ? Date.now() : p.completedAt,
    }));
  }, []);

  const setCustomTopic = useCallback((topic: CustomTopic) => {
    setProgress(p => ({ ...p, customTopic: topic }));
  }, []);

  const setQuizScore = useCallback((score: number) => {
    setProgress(p => ({ ...p, quizScore: score }));
  }, []);

  const setPersonalMove = useCallback((move: MoveKey) => {
    setProgress(p => ({ ...p, personalMove: move }));
  }, []);

  const reset = useCallback(() => setProgress(emptyProgress()), []);

  const completedCount = Object.values(progress.sections).filter(s => s.completed).length;
  const totalCount     = SECTIONS.length;
  const percent        = Math.round((completedCount / totalCount) * 100);

  return {
    progress,
    visit,
    complete,
    setCustomTopic,
    setQuizScore,
    setPersonalMove,
    reset,
    completedCount,
    totalCount,
    percent,
  };
}
'@

W 'src/components/ModuleShell/ModuleShell.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// ModuleShell — the outermost wrapper.
// Hosts: NavBar + ProgressBar + the section <Outlet/>.
// Provides ModuleProgressContext to all descendants.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { Outlet } from 'react-router-dom';
import { useModuleProgress } from '@/hooks/useModuleProgress';
import NavBar from '@/components/NavBar/NavBar';
import ProgressBar from '@/components/ProgressBar/ProgressBar';
import { ModuleProgressContext } from './ModuleProgressContext';
import styles from './ModuleShell.module.scss';

const ModuleShell: React.FC = () => {
  const progressApi = useModuleProgress();

  return (
    <ModuleProgressContext.Provider value={progressApi}>
      <div className={styles.shell}>
        <ProgressBar percent={progressApi.percent} />
        <NavBar />

        <main className={styles.main}>
          <Outlet />
        </main>
      </div>
    </ModuleProgressContext.Provider>
  );
};

export default ModuleShell;
'@

W 'src/components/ModuleShell/ModuleShell.module.scss' @'
.shell {
  min-height: 100vh;
}

.main {
  max-width: 880px;
  margin: 0 auto;
  padding: $space-6 $space-4 $space-8;

  @include respond-to(md) {
    padding: $space-7 $space-6 $space-8;
  }
}
'@

W 'src/components/ModuleShell/ModuleProgressContext.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// ModuleProgressContext — exposes useModuleProgress to all sections
// without prop-drilling.
// ═══════════════════════════════════════════════════════════════════
import { createContext, useContext } from 'react';
import { useModuleProgress } from '@/hooks/useModuleProgress';

type Ctx = ReturnType<typeof useModuleProgress>;

export const ModuleProgressContext = createContext<Ctx | null>(null);

export function useProgressCtx() {
  const ctx = useContext(ModuleProgressContext);
  if (!ctx) throw new Error('useProgressCtx must be inside a ModuleProgressContext.Provider');
  return ctx;
}
'@

W 'src/components/SectionShell/SectionShell.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// SectionShell — wraps every section.
// Header: section number + title + duration.
// Footer: prev/next buttons.
// Marks the section as visited on mount; complete on "next".
// Optional `canAdvance` prop gates the next button (e.g. break form).
// ═══════════════════════════════════════════════════════════════════
import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { TbArrowRight, TbArrowLeft } from 'react-icons/tb';
import { SECTION_BY_ID, SECTIONS } from '@/data/sections';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import type { SectionId } from '@/types/module.types';
import styles from './SectionShell.module.scss';

interface Props {
  id: SectionId;
  children: React.ReactNode;
  /** Gate the "next" button — defaults to true. */
  canAdvance?: boolean;
}

const SectionShell: React.FC<Props> = ({ id, children, canAdvance = true }) => {
  const section = SECTION_BY_ID[id];
  const { visit, complete } = useProgressCtx();
  const navigate = useNavigate();

  useEffect(() => { visit(id); }, [id, visit]);

  const idx = SECTIONS.findIndex(s => s.id === id);
  const prev = idx > 0 ? SECTIONS[idx - 1] : null;
  const next = idx < SECTIONS.length - 1 ? SECTIONS[idx + 1] : null;

  const handleNext = () => {
    if (!canAdvance) return;
    complete(id);
    if (next) navigate(next.path);
  };

  const handlePrev = () => {
    if (prev) navigate(prev.path);
  };

  return (
    <article className={styles.section}>
      {/* HEADER */}
      <header className={styles.head}>
        <div className={styles.headTop}>
          <span className={styles.partTag}>חלק {section.number} / {SECTIONS.length}</span>
          <span className={styles.duration}>{section.durationMin} דק׳</span>
        </div>
        <h1 className={styles.title}>{section.title}</h1>
        <p className={styles.subtitle}>{section.subtitle}</p>
      </header>

      {/* CONTENT */}
      <div className={styles.content}>{children}</div>

      {/* FOOTER NAV */}
      <footer className={styles.nav}>
        {prev ? (
          <button type="button" onClick={handlePrev} className={styles.prev}>
            <TbArrowRight aria-hidden />
            <span>{prev.title}</span>
          </button>
        ) : (
          <span />
        )}

        {next && (
          <button
            type="button"
            onClick={handleNext}
            disabled={!canAdvance}
            className={styles.next}
            title={!canAdvance ? 'יש להשלים את הפעולה הנדרשת בחלק הזה לפני המעבר הלאה' : undefined}
          >
            <span>{next.title}</span>
            <TbArrowLeft aria-hidden />
          </button>
        )}
      </footer>
    </article>
  );
};

export default SectionShell;
'@

W 'src/components/SectionShell/SectionShell.module.scss' @'
.section {
  @include flex-col;
  gap: $space-6;
}

// ── HEADER ─────────────────────────────────────────────────────
.head {
  @include flex-col;
  gap: $space-2;
  padding-bottom: $space-4;
  border-bottom: 2px dashed $paper-line;
}

.headTop {
  @include flex-between;
  align-items: baseline;
}

.partTag {
  font-family: $font-script;
  font-size: 20px;
  font-weight: $weight-bold;
  color: $red-pen;
  transform: rotate(-1.5deg);
  display: inline-block;
}

.duration {
  font-family: $font-mono;
  font-size: $text-sm;
  color: $ink-blue-soft;
  letter-spacing: 0.04em;
}

.title {
  font-family: $font-display;
  font-size: $text-3xl;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  line-height: 1.1;
  margin: 0;
}

.subtitle {
  font-family: $font-body;
  font-size: $text-md;
  color: $ink-blue-soft;
  margin: 0;
}

// ── CONTENT ────────────────────────────────────────────────────
.content {
  @include flex-col;
  gap: $space-5;
}

// ── FOOTER NAV ─────────────────────────────────────────────────
.nav {
  @include flex-between;
  margin-top: $space-6;
  padding-top: $space-5;
  border-top: 2px dashed $paper-line;
}

.prev, .next {
  @include flex-start;
  @include focus-ring;
  gap: $space-2;
  background: transparent;
  color: $ink-blue-dark;
  border: 1.5px solid $ink-blue-soft;
  border-radius: $radius-full;
  padding: $space-2 $space-5;
  font-family: $font-body;
  font-size: $text-sm;
  font-weight: $weight-medium;
  cursor: pointer;
  transition: all $dur-fast $ease-out;

  svg { font-size: 18px; }

  &:hover {
    background: $paper-cream;
    border-color: $ink-blue;
    transform: translateY(-1px);
  }
}

.next {
  background: $red-pen;
  color: $white;
  border-color: $red-pen;
  font-weight: $weight-bold;

  &:hover {
    background: $red-pen-dark;
    border-color: $red-pen-dark;
  }

  &:disabled {
    opacity: 0.4;
    cursor: not-allowed;
    &:hover { transform: none; background: $red-pen; }
  }
}
'@

W 'src/components/NavBar/NavBar.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// NavBar — top of the page.
// Brand on the right (RTL), 8 section circles on the left.
// Sketchbook aesthetic: handwritten accents, soft paper background.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { SECTIONS } from '@/data/sections';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import styles from './NavBar.module.scss';

const NavBar: React.FC = () => {
  const { progress } = useProgressCtx();
  const { pathname, hash } = useLocation();
  const currentPath = hash.replace('#', '') || pathname;

  return (
    <nav className={styles.nav} aria-label="ניווט בין חלקי המודול">
      <div className={styles.brand}>
        <span className={styles.brandTag}>M04</span>
        <span className={styles.brandTitle}>שלושה מהלכים</span>
      </div>

      <ol className={styles.dots}>
        {SECTIONS.slice().reverse().map((s) => {
          const state = progress.sections[s.id];
          const active = currentPath === s.path;
          const completed = state.completed;
          const visited = state.visited;
          return (
            <li key={s.id}>
              <Link
                to={s.path}
                className={[
                  styles.dot,
                  active && styles.dotActive,
                  completed && styles.dotDone,
                  !active && !completed && visited && styles.dotVisited,
                ].filter(Boolean).join(' ')}
                aria-current={active ? 'page' : undefined}
                aria-label={`${s.number}. ${s.title} — ${s.subtitle}`}
                title={`${s.number}. ${s.title} · ${s.subtitle}`}
              >
                {s.number}
              </Link>
            </li>
          );
        })}
      </ol>
    </nav>
  );
};

export default NavBar;
'@

W 'src/components/NavBar/NavBar.module.scss' @'
.nav {
  @include flex-between;
  flex-wrap: wrap;
  gap: $space-3;
  max-width: 880px;
  margin: 0 auto;
  padding: $space-4;

  @include respond-to(md) {
    padding: $space-4 $space-6;
  }
}

// ── BRAND ──────────────────────────────────────────────────────
.brand {
  @include flex-start;
  gap: $space-3;
}

.brandTag {
  font-family: $font-script;
  font-size: 22px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-3deg);
  display: inline-block;
}

.brandTitle {
  font-family: $font-display;
  font-size: $text-md;
  color: $ink-blue-dark;
  font-weight: $weight-bold;

  @include respond-to(md) { font-size: $text-lg; }
}

// ── DOTS (8 sections) ──────────────────────────────────────────
.dots {
  @include flex-start;
  gap: $space-2;
  list-style: none;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.dot {
  @include flex-center;
  @include focus-ring;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: $paper-cream;
  color: $ink-blue-soft;
  font-family: $font-mono;
  font-size: $text-sm;
  font-weight: $weight-medium;
  text-decoration: none;
  border: 1.5px solid $paper-cream-2;
  transition: all $dur-fast $ease-out;

  &:hover {
    background: $white;
    border-color: $pencil-light;
    transform: translateY(-1px);
  }
}

.dotActive {
  background: $red-pen;
  color: $white;
  border-color: $red-pen-dark;
  font-weight: $weight-bold;
  transform: scale(1.1);

  &:hover { background: $red-pen-dark; transform: scale(1.1) translateY(-1px); }
}

.dotDone {
  background: $ink-blue-dark;
  color: $paper-cream;
  border-color: $ink-blue-dark;

  &:hover { background: $ink-blue; }
}

.dotVisited {
  background: $paper-cream;
  color: $ink-blue;
  border-color: $pencil-light;
  border-style: dashed;
}
'@

W 'src/components/ProgressBar/ProgressBar.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// ProgressBar — thin stripe at the very top of the module.
// Goes from 0% to 100% as sections are completed.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import styles from './ProgressBar.module.scss';

interface Props { percent: number; }

const ProgressBar: React.FC<Props> = ({ percent }) => (
  <div className={styles.track} aria-hidden>
    <div
      className={styles.fill}
      style={{ width: `${Math.max(0, Math.min(100, percent))}%` }}
    />
  </div>
);

export default ProgressBar;
'@

W 'src/components/ProgressBar/ProgressBar.module.scss' @'
.track {
  height: 4px;
  background: rgba(44, 62, 80, 0.08);
  position: sticky;
  top: 0;
  z-index: $z-overlay;
}

.fill {
  height: 100%;
  background: linear-gradient(to left, $red-pen, $highlight, $red-pen);
  transition: width $dur-base $ease-out;
}
'@

W 'src/components/Placeholder/Placeholder.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// Placeholder — used by sections that haven't been built yet.
// Shows section meta + a friendly "coming soon" message.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbPencilOff } from 'react-icons/tb';
import SectionShell from '@/components/SectionShell/SectionShell';
import type { SectionId } from '@/types/module.types';
import styles from './Placeholder.module.scss';

interface Props { id: SectionId; }

const Placeholder: React.FC<Props> = ({ id }) => (
  <SectionShell id={id} canAdvance={false}>
    <div className={styles.empty}>
      <span className={styles.icon} aria-hidden><TbPencilOff /></span>
      <h3 className={styles.title}>חלק זה עוד לא נבנה</h3>
      <p>נחזור לבנות אותו ב-Phase הבאה. השאר עוגן בניווט למעלה.</p>
    </div>
  </SectionShell>
);

export default Placeholder;
'@

W 'src/components/Placeholder/Placeholder.module.scss' @'
.empty {
  @include paper-card;
  @include flex-col;
  align-items: center;
  text-align: center;
  gap: $space-3;
  padding: $space-7 $space-5;
  border: 1.5px dashed $pencil-light;
  background: transparent;
  box-shadow: none;
}

.icon {
  @include flex-center;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: $paper-cream;
  color: $pencil;
  font-size: 28px;
}

.title {
  font-family: $font-display;
  color: $ink-blue;
  font-size: $text-lg;
  font-weight: $weight-bold;
}

.empty p {
  font-size: $text-sm;
  color: $ink-blue-soft;
  max-width: 400px;
}
'@

W 'src/router/ModuleRouter.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// ModuleRouter — hash routing for iframe-safety.
// Built sections use lazy() so each is its own chunk.
// ═══════════════════════════════════════════════════════════════════
import React, { lazy, Suspense } from 'react';
import { createHashRouter, Navigate, RouterProvider } from 'react-router-dom';
import ModuleShell from '@/components/ModuleShell/ModuleShell';
import Placeholder from '@/components/Placeholder/Placeholder';

const OpeningSection = lazy(() => import('@/sections/01-opening'));

const withSuspense = (el: React.ReactNode) => (
  <Suspense fallback={null}>{el}</Suspense>
);

const router = createHashRouter([
  {
    path: '/',
    element: <ModuleShell />,
    children: [
      { index: true,        element: <Navigate to="/opening" replace /> },
      { path: 'opening',    element: withSuspense(<OpeningSection />) },
      { path: 'theory',     element: <Placeholder id="theory"    /> },
      { path: 'scenarios',  element: <Placeholder id="scenarios" /> },
      { path: 'break',      element: <Placeholder id="break"     /> },
      { path: 'voices',     element: <Placeholder id="voices"    /> },
      { path: 'case',       element: <Placeholder id="case"      /> },
      { path: 'personal',   element: <Placeholder id="personal"  /> },
      { path: 'closing',    element: <Placeholder id="closing"   /> },
      { path: '*',          element: <Navigate to="/opening" replace /> },
    ],
  },
]);

const ModuleRouter: React.FC = () => <RouterProvider router={router} />;
export default ModuleRouter;
'@

W 'src/sections/01-opening/index.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// Section 01 — פתיחה
// "השיעור הכי משמעותי. הכנה מהירה"
// Frames the prep problem + introduces the deliverable (4 PDFs).
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import OpeningHero from './OpeningHero';
import PrepProblem from './PrepProblem';

const OpeningSection: React.FC = () => (
  <SectionShell id="opening">
    <OpeningHero />
    <PrepProblem />
  </SectionShell>
);

export default OpeningSection;
'@

W 'src/sections/01-opening/OpeningHero.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// OpeningHero — the first thing the teacher sees.
// Big handwritten-feel title on a taped paper card.
// Eyebrow uses Caveat (script) and a Hebrew display font for the title.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbClock, TbFiles, TbSchool } from 'react-icons/tb';
import styles from './OpeningHero.module.scss';

const OpeningHero: React.FC = () => (
  <section className={styles.hero}>
    <span className={styles.eyebrow}>M04 · three moves</span>

    <h1 className={styles.title}>
     השיעור הכי משמעותי. הכנה מהירה
      <br />
      <span className={styles.accent}>עכשיו.</span>
    </h1>

    <p className={styles.lede}>
      <strong>3 שעות. 3 שיעורים מוכנים.</strong>{' '}
      אחד לכל גיל — יסודי, חט״ב, תיכון. פלוס שיעור אחד שאתם
      בונים לכיתה האמיתית שלכם. <em>בלי להתקע מול דף ריק.</em>
    </p>

    <ul className={styles.stats}>
      <li className={styles.stat}>
        <TbClock aria-hidden />
        <span>3 שעות</span>
      </li>
      <li className={styles.stat}>
        <TbFiles aria-hidden />
        <span>4 קובצי PDF</span>
      </li>
      <li className={styles.stat}>
        <TbSchool aria-hidden />
        <span>יסודי · חט״ב · תיכון</span>
      </li>
    </ul>
  </section>
);

export default OpeningHero;
'@

W 'src/sections/01-opening/OpeningHero.module.scss' @'
.hero {
  @include taped-card;
  text-align: center;
  padding: $space-8 $space-5 $space-6;

  @include respond-to(md) {
    padding: $space-8 $space-7 $space-7;
  }
}

.eyebrow {
  font-family: $font-script;
  font-size: 22px;
  color: $red-pen;
  font-weight: $weight-bold;
  display: inline-block;
  transform: rotate(-1.5deg);
  margin-bottom: $space-3;
  letter-spacing: 0.02em;
}

.title {
  font-family: $font-display;
  font-size: $text-2xl;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  line-height: 1.05;
  letter-spacing: -0.01em;
  margin: 0 0 $space-4;

  @include respond-to(md) { font-size: 52px; }

  br + .accent {
    margin-top: 0.2em;
    display: inline-block;
  }
}

.accent {
  @include pen-underline($red-pen, 4px);
  color: $red-pen;
}

.lede {
  font-size: $text-md;
  line-height: $leading-loose;
  color: $ink-blue-soft;
  max-width: 580px;
  margin: 0 auto $space-5;

  strong {
    color: $ink-blue-dark;
    font-weight: $weight-bold;
  }

  em {
    font-style: italic;
    color: $red-pen;
    font-weight: $weight-medium;
  }
}

// ── STATS ──────────────────────────────────────────────────────
.stats {
  @include flex-center;
  flex-wrap: wrap;
  gap: $space-3;
  list-style: none;
  margin: 0;
}

.stat {
  @include flex-start;
  gap: $space-2;
  background: $paper-cream-2;
  color: $ink-blue;
  padding: $space-2 $space-4;
  border-radius: $radius-full;
  border: 1.5px solid $paper-line;
  font-family: $font-mono;
  font-size: $text-sm;

  svg { font-size: 16px; color: $red-pen; }
}
'@

W 'src/sections/01-opening/PrepProblem.tsx' @'
// ═══════════════════════════════════════════════════════════════════
// PrepProblem — the "why this module exists" narrative.
// Three sticky-note quotes from real teacher pain points,
// then a synthesis paragraph.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import styles from './PrepProblem.module.scss';

interface Pain {
  quote: string;
  role: string;
  rotation: number;
  bg: 'yellow' | 'cream' | 'kraft';
}

const PAINS: Pain[] = [
  {
    quote: 'יום ראשון, 8:00. כיתה ז\'1 כבר במסדרון. ואני... עדיין לא יודעת על מה אדבר היום.',
    role: 'מחנכת חט״ב',
    rotation: -2,
    bg: 'yellow',
  },
  {
    quote: 'ב-13:00 הייתה תקרית בכיתה. ב-13:30 אני צריך לדבר עליה — בלי לעשות נזק.',
    role: 'מחנך יסודי',
    rotation: 1.5,
    bg: 'cream',
  },
  {
    quote: 'המנהל ביקש שיעור על אנטישמיות. אני... אפילו לא יודעת איך להתחיל.',
    role: 'מחנכת תיכון',
    rotation: -1,
    bg: 'kraft',
  },
];

const PrepProblem: React.FC = () => (
  <section className={styles.section}>
    <header className={styles.intro}>
      <span className={styles.tag}>הבעיה</span>
      <h2 className={styles.title}>
        שיעור חינוך הוא <em>השיעור הכי קשה להכין.</em>
      </h2>
      <p className={styles.lede}>
        אין ספר. אין סילבוס. אין תשובה נכונה אחת. רק אתם, התלמידים, ו-45 דקות
        שצריכות להיות <span className={styles.hl}>משמעותיות</span>.
      </p>
    </header>

    <ul className={styles.pains} aria-label="דוגמאות לקושי בהכנת שיעור חינוך">
      {PAINS.map((p, i) => (
        <li
          key={i}
          className={`${styles.pain} ${styles[`pain-${p.bg}`]}`}
          style={{ '--rot': `${p.rotation}deg` } as React.CSSProperties}
        >
          <blockquote className={styles.quote}>“{p.quote}”</blockquote>
          <cite className={styles.role}>— {p.role}</cite>
        </li>
      ))}
    </ul>

    <aside className={styles.bridge}>
      <span className={styles.bridgeBadge}>מה נלמד</span>
      <p>
        המודול הזה לוקח את 90 הדקות של הכנה (כשיש לכם זמן) ל-15 דקות (כשאין).
        <strong> 3 מהלכים. 3 שיעורים מוכנים. שיעור אחד משלכם.</strong>
      </p>
    </aside>
  </section>
);

export default PrepProblem;
'@

W 'src/sections/01-opening/PrepProblem.module.scss' @'
.section {
  @include flex-col;
  gap: $space-5;
  margin-top: $space-3;
}

// ── INTRO ──────────────────────────────────────────────────────
.intro { @include flex-col; gap: $space-2; }

.tag {
  font-family: $font-script;
  font-size: 20px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.title {
  font-family: $font-display;
  font-size: $text-xl;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  line-height: 1.15;
  margin: 0;

  em {
    font-style: italic;
    color: $red-pen;
    font-weight: $weight-bold;
  }

  @include respond-to(md) { font-size: $text-2xl; }
}

.lede {
  font-size: $text-md;
  color: $ink-blue-soft;
  line-height: $leading-loose;
  max-width: 620px;
}

.hl {
  @include highlighter($highlight);
  color: $ink-blue-dark;
  font-weight: $weight-bold;
}

// ── PAINS (sticky notes) ───────────────────────────────────────
.pains {
  list-style: none;
  display: grid;
  gap: $space-5 $space-4;
  grid-template-columns: 1fr;
  margin-top: $space-3;

  @include respond-to(md) {
    grid-template-columns: repeat(3, 1fr);
    gap: $space-5;
  }
}

.pain {
  @include sticky-note($bg: $highlight-pale, $rotation: 0deg);
  transform: rotate(var(--rot, 0deg));
  @include flex-col;
  gap: $space-3;
  padding: $space-4 $space-5 $space-5;
  min-height: 160px;
  transition: transform $dur-base $ease-out;

  &:hover { transform: rotate(0) translateY(-2px); }
}

.pain-yellow { background: $highlight-pale; }
.pain-cream  { background: $paper-cream; }
.pain-kraft  { background: $sticky-kraft; }

.quote {
  margin: 0;
  font-family: $font-body;
  font-size: $text-base;
  line-height: $leading-body;
  color: $ink-blue-dark;
  font-weight: $weight-medium;
}

.role {
  font-family: $font-script;
  font-size: $text-md;
  color: $ink-blue-soft;
  font-style: normal;
  align-self: flex-end;
}

// ── BRIDGE ─────────────────────────────────────────────────────
.bridge {
  display: grid;
  grid-template-columns: auto 1fr;
  gap: $space-3;
  align-items: center;
  margin-top: $space-3;
  padding: $space-4 $space-5;
  background: $paper-cream;
  border-right: 4px solid $red-pen;
  border-radius: $radius-md;
  box-shadow: $shadow-paper;
}

.bridgeBadge {
  font-family: $font-mono;
  font-size: 10px;
  font-weight: $weight-bold;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  background: $red-pen;
  color: $white;
  padding: 4px $space-2;
  border-radius: $radius-sm;
  white-space: nowrap;
}

.bridge p {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue;

  strong {
    color: $ink-blue-dark;
    font-weight: $weight-bold;
  }
}
'@

Write-Host ""
Write-Host "=================================" -ForegroundColor Yellow
Write-Host "Phase 1 written. Next steps:" -ForegroundColor Yellow
Write-Host "  1. npm install" -ForegroundColor Yellow
Write-Host "  2. npm run dev" -ForegroundColor Yellow
Write-Host "  3. open http://localhost:5173/" -ForegroundColor Yellow
Write-Host "=================================" -ForegroundColor Yellow
