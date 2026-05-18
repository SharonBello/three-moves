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