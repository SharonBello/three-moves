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