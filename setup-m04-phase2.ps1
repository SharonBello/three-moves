# ═══════════════════════════════════════════════════════════════════
# setup-m04-phase2.ps1
# M04 · Three Moves — Sections 2-8 + router wiring + OpeningHero
# title lock-in.
#
# USAGE (from project root: ...\sharon_workspace\three-moves\):
#   PS> Unblock-File .\setup-m04-phase2.ps1
#   PS> .\setup-m04-phase2.ps1
#   PS> npm run dev
#
# Creates ~43 files. Safe to re-run (overwrites existing).
# ═══════════════════════════════════════════════════════════════════

$ErrorActionPreference = 'Stop'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Write-Source {
    param([string]$Path, [string]$Body)
    $full = Join-Path -Path (Get-Location) -ChildPath $Path
    $dir  = Split-Path -Parent $full
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    [System.IO.File]::WriteAllText($full, $Body, $utf8NoBom)
    Write-Host "  + $Path" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  M04 · Phase 2 · Sections 2-8 + router + opening lock-in" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Source -Path 'src/sections/01-opening/OpeningHero.tsx' -Body @'
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
      השיעור הכי משמעותי
      <br />
      <span className={styles.accent}>הכנה מהירה</span>
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
Write-Source -Path 'src/router/ModuleRouter.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// ModuleRouter — hash routing for iframe-safety.
// All 8 sections lazy-loaded; each is its own chunk.
// ═══════════════════════════════════════════════════════════════════
import React, { lazy, Suspense } from 'react';
import { createHashRouter, Navigate, RouterProvider } from 'react-router-dom';
import ModuleShell from '@/components/ModuleShell/ModuleShell';

const OpeningSection   = lazy(() => import('@/sections/01-opening'));
const TheorySection    = lazy(() => import('@/sections/02-theory'));
const ScenariosSection = lazy(() => import('@/sections/03-scenarios'));
const BreakSection     = lazy(() => import('@/sections/04-break'));
const VoicesSection    = lazy(() => import('@/sections/05-voices'));
const CaseSection      = lazy(() => import('@/sections/06-case'));
const PersonalSection  = lazy(() => import('@/sections/07-personal'));
const ClosingSection   = lazy(() => import('@/sections/08-closing'));

const withSuspense = (el: React.ReactNode) => (
  <Suspense fallback={null}>{el}</Suspense>
);

const router = createHashRouter([
  {
    path: '/',
    element: <ModuleShell />,
    children: [
      { index: true,        element: <Navigate to="/opening" replace /> },
      { path: 'opening',    element: withSuspense(<OpeningSection   />) },
      { path: 'theory',     element: withSuspense(<TheorySection    />) },
      { path: 'scenarios',  element: withSuspense(<ScenariosSection />) },
      { path: 'break',      element: withSuspense(<BreakSection     />) },
      { path: 'voices',     element: withSuspense(<VoicesSection    />) },
      { path: 'case',       element: withSuspense(<CaseSection      />) },
      { path: 'personal',   element: withSuspense(<PersonalSection  />) },
      { path: 'closing',    element: withSuspense(<ClosingSection   />) },
      { path: '*',          element: <Navigate to="/opening" replace /> },
    ],
  },
]);

const ModuleRouter: React.FC = () => <RouterProvider router={router} />;
export default ModuleRouter;
'@
Write-Source -Path 'src/data/threeMoves.ts' -Body @'
// ═══════════════════════════════════════════════════════════════════
// M04 · Three Moves Data
// The 3 reusable patterns for AI-assisted shiur chinuch prep.
// Each one pairs with the age tier where its value is most striking,
// but ALL three can be used at any age — the age pairing is pedagogical
// fit, not a hard rule.
// ═══════════════════════════════════════════════════════════════════
import type { MoveKey, AgeTier } from '@/types/module.types';

export interface Move {
  id: MoveKey;
  number: 1 | 2 | 3;
  nameHe: string;
  nameEn: string;
  /** The age tier where this move shines. */
  bestFor: { tier: AgeTier; label: string; emoji: string };
  /** One-line punch — what AI does that you couldn't easily do alone. */
  superpower: string;
  /** 1-2 sentence description with concrete framing. */
  description: string;
  /** "before → after" — the transformation in one phrase. */
  transform: { from: string; to: string };
  /** A one-line demo topic that this move will be applied to in its section. */
  demoTopic: string;
  /** Visual tint for the card. */
  tint: 'yellow' | 'blue' | 'red';
}

export const MOVES: Move[] = [
  {
    id: 'scenarios',
    number: 1,
    nameHe: 'מחולל תרחישים',
    nameEn: 'Scenario Generator',
    bestFor: { tier: 'elementary', label: 'יסודי', emoji: '🎒' },
    superpower: 'הופך נושא מופשט לסיפורים שילדים מתחברים אליהם.',
    description:
      'במקום ללמד על "כבוד" — סיפור על ילד שגנבו לו את הכובע. הסיפור עושה את העבודה. AI מייצר אותם בקצב שלכם.',
    transform: { from: 'מופשט', to: '3 סיפורים קונקרטיים' },
    demoTopic: 'הילד שיושב לבד בהפסקה · כיתה ד׳',
    tint: 'yellow',
  },
  {
    id: 'voices',
    number: 2,
    nameHe: 'שלוש קולות',
    nameEn: 'Three Voices',
    bestFor: { tier: 'middle', label: 'חט״ב', emoji: '📱' },
    superpower: 'מציג את אותו אירוע משלוש פרספקטיבות: מורה · תלמיד · הורה.',
    description:
      'בגיל הזה התלמידים בעיקר רואים את עצמם. AI עוזר להציג גם את הקול של האחר — של ההורה, של המורה, של מי שנפגע — בלי הטפה.',
    transform: { from: 'נקודת מבט אחת', to: '3 פרספקטיבות' },
    demoTopic: 'רכילות בקבוצת WhatsApp · כיתה ח׳',
    tint: 'blue',
  },
  {
    id: 'case',
    number: 3,
    nameHe: 'מהמקרה אל הערך',
    nameEn: 'Backwards from Case',
    bestFor: { tier: 'high', label: 'תיכון', emoji: '🎓' },
    superpower: 'מתחיל ממקרה אמיתי, מחלץ את העיקרון, ובונה דיון עמוק.',
    description:
      'תלמידי תיכון מזהים סיסמאות מקילומטר. AI מתחיל מסיפור אמיתי (חדשות, מקרה אישי) ועוזר לחשוף את השאלה הגדולה שמתחתיו — בלי להגיש תשובה.',
    transform: { from: 'אירוע יחיד', to: 'שאלה ערכית' },
    demoTopic: 'חיים אחרי הצבא · כיתה י״ב',
    tint: 'red',
  },
];

export const MOVE_BY_ID: Record<MoveKey, Move> = MOVES.reduce(
  (acc, m) => { acc[m.id] = m; return acc; },
  {} as Record<MoveKey, Move>,
);
'@
Write-Source -Path 'src/data/moveDemos.ts' -Body @'
// ═══════════════════════════════════════════════════════════════════
// M04 · Move Demo Content
// The concrete data for the 3 demo lessons. Each move section
// imports its slice from here.
// ═══════════════════════════════════════════════════════════════════

// ── MOVE 1 · SCENARIO GENERATOR · יסודי ────────────────────────
export const SCENARIO_DEMO = {
  topic: 'הילד שיושב לבד בהפסקה',
  grade: 'כיתה ד׳',
  prompt: {
    role: 'מומחה/ית להוראת חינוך בכיתות יסודי. את/ה מתמחה בבניית סיפורים קצרים שעוזרים לילדים לדבר על רגשות בלי הטפה.',
    context: 'אני מחנכ/ת של כיתה ד׳1. שמתי לב שיש ילד אחד שיושב לבד בהפסקה כבר שבועיים. אני רוצה לעשות שיעור חינוך על שייכות וחברות — בלי להצביע על אף אחד.',
    task: 'צור/י 3 סיפורים קצרים על ילדים בכיתה ד׳, כל אחד שלא משתלב מסיבה אחרת (חדש בכיתה / ביישן / סיבה לא ברורה). כל סיפור עם שם וסיטואציה קונקרטית.',
    format: 'לכל סיפור עד 120 מילים. אחרי כל סיפור — 4 שאלות לדיון בכיתה. בסוף — פעילות סיכום אחת ל-15 דקות שמחברת את כל הסיפורים.',
  },
  stories: [
    {
      name: 'עומר',
      cause: 'חדש בכיתה',
      preview: 'עומר עבר לבית הספר לפני חודש. הוא מבין עברית אבל לא מדבר הרבה — חושש שיצחקו עליו. בהפסקה הוא יושב על הספסל ליד הספרייה. ילדים עוברים, מסתכלים, ממשיכים. הוא רוצה לבקש להצטרף למשחק כדורגל אבל לא יודע איך לפתוח.',
    },
    {
      name: 'דניאל',
      cause: 'ביישן',
      preview: 'דניאל בכיתה הזאת מאז כיתה א׳. יש לו חבר אחד טוב — אורי — אבל אורי חולה השבוע. דניאל פתאום מגלה שאין לו עם מי לאכול. הוא יושב בכיתה ועושה שאלא־הוא־כבר־סיים אבל בעצם רק נמצא שם.',
    },
    {
      name: 'תמר',
      cause: 'אין סיבה ברורה',
      preview: 'תמר ילדה נחמדה. צוחקת בשיעור, עונה כשקוראים לה. אבל בהפסקה — שום קבוצה לא קוראת לה ושום קבוצה היא לא קוראת. זה קרה לאט. אף אחד לא יודע מתי בדיוק. תמר עצמה כבר לא בטוחה אם היא רוצה שיקראו לה או שתישאר לבד.',
    },
  ],
  activity: {
    name: 'מפת חברויות',
    duration: '15 דק׳',
    steps: [
      'כל ילד מקבל דף ריק וכותב את שמו במרכז.',
      'מסביב לשם — כותב את 3-5 הילדים שהוא הכי מחובר אליהם בכיתה.',
      'מצייר קו לכל אחד שכתב.',
      'בעיגול בצד — מי לדעתו אין על המפה של אף אחד? (בלי לכתוב שמות בקול)',
      'דיון: מה צריך לקרות כדי שזה ישתנה?',
    ],
  },
  plan: {
    totalMin: 45,
    blocks: [
      { time: '0–5', name: 'פתיח', body: 'שאלה פתוחה: "מתי הרגשתם פעם בודדים בכיתה?" — להעלות הצבעות בלי מילים.' },
      { time: '5–30', name: 'סיפורים', body: '3 סיפורים × 8 דק׳ — קוראים, דנים ב-4 שאלות, ממשיכים.' },
      { time: '30–42', name: 'פעילות', body: 'מפת חברויות — אישית ואז שיתוף בזוגות.' },
      { time: '42–45', name: 'סיכום', body: '"מה אני יכול/ה לעשות מחר?" — משפט אחד בלב.' },
    ],
  },
};

// ── MOVE 2 · THREE VOICES · חט״ב ───────────────────────────────
export const VOICES_DEMO = {
  topic: 'רכילות בקבוצת WhatsApp',
  grade: 'כיתה ח׳',
  prompt: {
    role: 'מומחה/ית להוראת חינוך לחט״ב. את/ה מתמחה בדיונים על דינמיקה חברתית מקוונת בלי הטפה.',
    context: 'אני מחנכ/ת של כיתה ח׳. בסוף השבוע התפוצצה דרמה בקבוצת WhatsApp של הכיתה — מישהי הוצאה מהקבוצה, אחר כך הוכנסה חזרה, ובינתיים נכתבו דברים. אני רוצה לדבר על זה בלי להצביע על איש.',
    task: 'תאר/י את אותו אירוע בדיוק משלוש פרספקטיבות: (1) המורה שמסתכלת מבחוץ, (2) תלמיד/ה בכיתה שלא פעל/ה אבל ראה/תה, (3) הורה שמקבל/ת על זה בערב מהילד/ה. כל קול ב-100-150 מילים, בגוף ראשון, באוצר מילים מציאותי לגיל.',
    format: 'אחרי שלושת הקולות — פרוטוקול "4 פינות" לדיון: 4 עמדות אפשריות שתלמידים יכולים לעמוד בהן (הצטרפתי / שתקתי / יצאתי / עצרתי), עם שאלה ספציפית לכל עמדה.',
  },
  voices: [
    {
      who: 'המורה',
      perspective: 'מבחוץ',
      preview:
        'יום שני, 7:55. אני נכנסת לחדר מורים ושני מורים אחרים כבר יודעים. "ראית מה היה אצלכם בקבוצה?" אני לא ראיתי, אני לא חברה בקבוצה. בהפסקה ראיתי שתי בנות שיוצאות מהשירותים בעיניים אדומות. אני לא יודעת מי כתבה מה ומי בכלל היה ער ב-23:40 בלילה. אני יודעת ש-15 ילדים נכנסים אליי לכיתה בעוד עשר דקות, וצריך לעשות עם זה משהו.',
    },
    {
      who: 'תלמיד/ה',
      perspective: 'ראה/תה אבל לא פעל/ה',
      preview:
        'ראיתי כשהוציאו את מאיה. הייתי בקבוצה. ניסיתי להגיד "די" אבל ראיתי שהמסר שלי לא קיבל לבבות וכולם המשיכו. אחרי שתי דקות מחקתי את ההודעה שלי. למחרת היא בכתה במסדרון ואני עברתי לידה כאילו לא ראיתי. אני לא יודעת אם זה גרוע יותר מלהוציא אותה.',
    },
    {
      who: 'ההורה',
      perspective: 'גילה מאוחר',
      preview:
        'הילדה שלי חזרה מהיום בית ספר וסגרה את הדלת. שאלתי "הכל בסדר?" — קיבלתי "כן". בערב, תוך כדי כביסה, היא אמרה לי בטון רגוע: "הוציאו את מאיה מהקבוצה אתמול, אבל בסוף החזירו אותה". אני לא רוצה לעשות מזה סיפור גדול אבל אני לא יודעת אם הילדה שלי הייתה זאת שהוציאה, אחת מהשותקות, או מי שעצרה. ואני לא רוצה לשאול ישירות.',
    },
  ],
  protocol: {
    name: '4 פינות',
    duration: '20 דק׳',
    description:
      '4 כרזות בכיתה, אחת בכל פינה. כל תלמיד עומד בפינה שמתאר אותו הכי טוב בסיטואציה כזאת. אחר כך — כל פינה משתפת. אין שיפוט, רק תיאור.',
    corners: [
      { label: 'הצטרפתי', q: 'מה גרם לכם להצטרף? מתי הבנתם שזה הלך רחוק מדי?' },
      { label: 'שתקתי',   q: 'מה היה צריך לקרות כדי שתדברו? למה זה לא קרה?' },
      { label: 'יצאתי',   q: 'יציאה היא גם מהלך. למה זה הרגיש כמו האופציה היחידה?' },
      { label: 'עצרתי',   q: 'איך הצלחתם? מה תרצו שתלמיד אחר יידע לפני שזה יקרה לו?' },
    ],
  },
  plan: {
    totalMin: 45,
    blocks: [
      { time: '0–5',   name: 'פתיח',    body: 'מציגים שלוש כותרות (מורה / תלמיד/ה / הורה) — "אותו ערב, שלושה אנשים".' },
      { time: '5–20',  name: 'הקולות',  body: 'קוראים בקול את שלושת הקולות. בלי דיון בין לבין — רק שומעים.' },
      { time: '20–40', name: '4 פינות', body: '20 דק׳: עמידה בפינות + שיחה לפי השאלות.' },
      { time: '40–45', name: 'סיכום',   body: 'משפט אחד אישי: "בפעם הבאה אני אעשה ___".' },
    ],
  },
};

// ── MOVE 3 · BACKWARDS FROM CASE · תיכון ───────────────────────
export const CASE_DEMO = {
  topic: 'חיים אחרי הצבא — בלי תשובה נכונה',
  grade: 'כיתה י״ב',
  prompt: {
    role: 'מומחה/ית להוראת חינוך לתיכון. את/ה מתמחה בדיונים על דילמות ערכיות בלי לדחוף מסקנה אחת.',
    context: 'אני מחנכ/ת של כיתה י״ב. עוד 8 חודשים הם משתחררים מהצבא ועומדים בפני בחירות גדולות — אוניברסיטה / שנת שירות / טיול גדול / עבודה / שילובים. רוצה שיעור חינוך עמוק, בלי "אתם צריכים".',
    task: 'תאר/י 5 מקרים אמיתיים מהשנים האחרונות של בוגרי תיכון בני 23, כל אחד שבחר מסלול אחר. לכל מקרה — מה הם רואים עכשיו כתועלת, ומה היו עושים אחרת. אחר כך — חלץ/י את ה־3 ערכים המרכזיים שמתחת לבחירות (לא "להיות חכם" — אלא יציבות / חופש / משמעות וכו׳).',
    format: '5 כרטיסיות מקרה (כל אחת 100 מילים) + לוח של 12 ערכים לבחירה (קלפי ערכים) + שלוש שאלות סיכום שמובילות לפעולה ברורה לתלמיד.',
  },
  cases: [
    { path: 'אוניברסיטה מיד',        outcome: 'התחילה תואר במשפטים בגיל 21. גמרה לפני כולם. עכשיו מתחרטת שלא ראתה את העולם.' },
    { path: 'שנת שירות',              outcome: 'עבד שנה במרכז קליטה. אומר שזאת הייתה השנה הכי משמעותית — ואז למד הנדסה והתקבל לחלום שלו.' },
    { path: 'טיול גדול',              outcome: 'שנתיים בדרום אמריקה. חזרה בשקט. עכשיו מתלבטת אם הזמן ההוא היה חופש או דחיינות.' },
    { path: 'עבודה ולימודי ערב',     outcome: 'עבד והשתלם בערבים. הרוויח כסף, צבר ניסיון, אבל מרגיש שלא חווה את "האוניברסיטה" כחוויה.' },
    { path: 'משולב — חזר/חזרה ללמוד אחרי שנה', outcome: 'התגייסה לעוד שנה במילואים אחרי השחרור. אחר כך תואר. אומרת שזה היה איזון.' },
  ],
  values: [
    'יציבות',  'חופש',     'משמעות',  'כסף',
    'חברות',   'הצלחה',     'גמישות', 'הכרת העולם',
    'משפחה',  'התחדשות', 'עומק',    'הוכחה לעצמי',
  ],
  closingQuestions: [
    'איזה ערך אצלכם בולט יותר מהאחרים — אחד שיוכל להנחות החלטה ממש בשבועיים הקרובים?',
    'איזה ערך הופתעתם שדורג בכם גבוה? למה?',
    'אם הייתם פוגשים את הגרסה שלכם בעוד 5 שנים — מה הייתם רוצים להגיד לעצמכם עכשיו?',
  ],
  plan: {
    totalMin: 45,
    blocks: [
      { time: '0–5',   name: 'פתיח',     body: 'שאלה פתוחה: "כשמישהו בן 23 מסתכל אחורה — מה הוא רואה?"' },
      { time: '5–20',  name: 'מקרים',    body: '5 כרטיסיות מקרה. קוראים בקבוצות קטנות, מסכמים בכיתה.' },
      { time: '20–35', name: 'קלפי ערכים', body: 'כל תלמיד/ה מסדר/ת את 12 הערכים בשורה מ"הכי חשוב לי" ל"פחות".' },
      { time: '35–43', name: 'דיון',      body: '3 שאלות סיכום. אופציה: שיתוף בזוגות לפני קבוצה.' },
      { time: '43–45', name: 'סיגניות', body: 'משפט אחד אישי בלב: "המסלול שמתאים לערך הראשון שלי הוא ___".' },
    ],
  },
};
'@
Write-Source -Path 'src/components/MoveDemoIntro/MoveDemoIntro.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// MoveDemoIntro — header card for any of the 3 move-demo sections.
// Shows: move number/name, age tier badge, demo topic, framing line.
// Reused by sections 3 (scenarios), 5 (voices), 6 (case).
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbBolt } from 'react-icons/tb';
import type { Move } from '@/data/threeMoves';
import styles from './MoveDemoIntro.module.scss';

interface Props {
  move: Move;
  /** The concrete topic this demo applies the move to */
  demoTopic: string;
  /** Optional grade label override (e.g., "כיתה ד׳") */
  gradeLabel?: string;
}

const MoveDemoIntro: React.FC<Props> = ({ move, demoTopic, gradeLabel }) => (
  <section className={`${styles.hero} ${styles[`tint-${move.tint}`]}`}>
    <header className={styles.head}>
      <span className={styles.num}>מהלך {move.number}</span>
      <span className={styles.age}>
        <span aria-hidden>{move.bestFor.emoji}</span> {move.bestFor.label}
      </span>
    </header>

    <h2 className={styles.name}>
      {move.nameHe}
      <span className={styles.nameEn}>{move.nameEn}</span>
    </h2>

    <p className={styles.superpower}>
      <TbBolt aria-hidden className={styles.boltIcon} />
      <span>{move.superpower}</span>
    </p>

    <div className={styles.topic}>
      <span className={styles.topicLabel}>הנושא לדמו</span>
      <span className={styles.topicValue}>
        {demoTopic}
        {gradeLabel && <span className={styles.topicGrade}> · {gradeLabel}</span>}
      </span>
    </div>
  </section>
);

export default MoveDemoIntro;
'@
Write-Source -Path 'src/components/MoveDemoIntro/MoveDemoIntro.module.scss' -Body @'
.hero {
  @include paper-card;
  padding: $space-5 $space-5 $space-4;
  border-top: 4px solid $red-pen;
  @include flex-col;
  gap: $space-3;
}

// Tint variants — top accent border + small bg wash
.tint-yellow {
  border-top-color: $highlight-dark;
  background: linear-gradient(to bottom, $highlight-pale 0%, $paper-cream 80px);
}

.tint-blue {
  border-top-color: $tape-washi-dark;
  background: linear-gradient(to bottom, rgba(168, 200, 218, 0.3) 0%, $paper-cream 80px);
}

.tint-red {
  border-top-color: $red-pen;
  background: linear-gradient(to bottom, $red-pen-pale 0%, $paper-cream 80px);
}

// ── HEAD ───────────────────────────────────────────────────────
.head {
  @include flex-between;
  align-items: baseline;
}

.num {
  font-family: $font-mono;
  font-size: $text-sm;
  font-weight: $weight-bold;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: $red-pen;
}

.age {
  @include flex-start;
  gap: $space-1;
  font-family: $font-script;
  font-size: 20px;
  color: $ink-blue-dark;
  font-weight: $weight-bold;
}

// ── NAME ───────────────────────────────────────────────────────
.name {
  @include flex-col;
  gap: 2px;
  margin: 0;
  font-family: $font-display;
  font-size: $text-2xl;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  line-height: 1.1;
}

.nameEn {
  font-family: $font-script;
  font-size: $text-lg;
  color: $red-pen;
  font-weight: $weight-medium;
}

// ── SUPERPOWER ─────────────────────────────────────────────────
.superpower {
  @include flex-start;
  gap: $space-2;
  margin: 0;
  font-size: $text-md;
  line-height: $leading-body;
  color: $ink-blue;
  font-weight: $weight-medium;
}

.boltIcon {
  font-size: 20px;
  color: $red-pen;
  flex-shrink: 0;
}

// ── TOPIC ──────────────────────────────────────────────────────
.topic {
  @include flex-col;
  gap: 2px;
  margin-top: $space-2;
  padding: $space-3 $space-4;
  background: $paper-cream-2;
  border-radius: $radius-md;
  border-right: 3px solid $red-pen;
}

.topicLabel {
  font-family: $font-mono;
  font-size: 10px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: $ink-blue-soft;
}

.topicValue {
  font-family: $font-display;
  font-size: $text-md;
  color: $ink-blue-dark;
  font-weight: $weight-bold;
}

.topicGrade {
  color: $ink-blue-soft;
  font-weight: $weight-medium;
}
'@
Write-Source -Path 'src/components/PromptDemo/PromptDemo.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// PromptDemo — shows the 4-part prompt the workshop teaches.
// Reused by all 3 move-demo sections.
// Has a "copy whole prompt" button that joins the 4 parts into one block.
// ═══════════════════════════════════════════════════════════════════
import React, { useState } from 'react';
import { TbCopy, TbCheck } from 'react-icons/tb';
import styles from './PromptDemo.module.scss';

export interface FourPartPrompt {
  role:    string;
  context: string;
  task:    string;
  format:  string;
}

interface Props { prompt: FourPartPrompt; }

const LABELS: Record<keyof FourPartPrompt, { he: string; tag: string }> = {
  role:    { he: 'תפקיד',  tag: 'ROLE' },
  context: { he: 'קשר',    tag: 'CONTEXT' },
  task:    { he: 'משימה',  tag: 'TASK' },
  format:  { he: 'פורמט',  tag: 'FORMAT' },
};

function buildFullPrompt(p: FourPartPrompt): string {
  return [
    `תפקיד: ${p.role}`,
    `קשר: ${p.context}`,
    `משימה: ${p.task}`,
    `פורמט: ${p.format}`,
  ].join('\n\n');
}

const PromptDemo: React.FC<Props> = ({ prompt }) => {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    const text = buildFullPrompt(prompt);
    try {
      await navigator.clipboard.writeText(text);
      setCopied(true);
      setTimeout(() => setCopied(false), 1800);
    } catch {
      // Fallback: select+copy via temp textarea
      const ta = document.createElement('textarea');
      ta.value = text;
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand('copy'); setCopied(true); setTimeout(() => setCopied(false), 1800); }
      finally { document.body.removeChild(ta); }
    }
  };

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.tag}>הפרומפט</span>
        <h3 className={styles.title}>4 חלקים. תבנית קבועה.</h3>
        <p className={styles.lede}>
          העתיקו את הפרומפט המלא, הדביקו ב-ChatGPT/Claude/Gemini, ותקבלו את הפלט למטה.
        </p>
      </header>

      <ol className={styles.parts}>
        {(Object.keys(LABELS) as (keyof FourPartPrompt)[]).map((k) => (
          <li key={k} className={styles.part}>
            <header className={styles.partHead}>
              <span className={styles.partTag}>{LABELS[k].tag}</span>
              <span className={styles.partHe}>{LABELS[k].he}</span>
            </header>
            <p className={styles.partBody}>{prompt[k]}</p>
          </li>
        ))}
      </ol>

      <div className={styles.copyRow}>
        <button
          type="button"
          className={`${styles.copyBtn} ${copied ? styles.copyBtnDone : ''}`}
          onClick={handleCopy}
        >
          {copied ? <TbCheck aria-hidden /> : <TbCopy aria-hidden />}
          <span>{copied ? 'הועתק!' : 'העתיקו את הפרומפט המלא'}</span>
        </button>
      </div>
    </section>
  );
};

export default PromptDemo;
'@
Write-Source -Path 'src/components/PromptDemo/PromptDemo.module.scss' -Body @'
.section {
  @include flex-col;
  gap: $space-4;
}

// ── HEAD ───────────────────────────────────────────────────────
.head { @include flex-col; gap: $space-1; }

.tag {
  font-family: $font-script;
  font-size: 22px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.title {
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin: 0;

  @include respond-to(md) { font-size: $text-xl; }
}

.lede {
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue-soft;
  margin: 0;
}

// ── PARTS ──────────────────────────────────────────────────────
.parts {
  list-style: none;
  margin: 0;
  padding: 0;
  @include flex-col;
  gap: $space-3;
}

.part {
  @include paper-card;
  padding: $space-3 $space-4;
  border-inline-start: 3px solid $tape-washi;
}

.partHead {
  @include flex-start;
  gap: $space-2;
  margin-bottom: $space-1;
}

.partTag {
  font-family: $font-mono;
  font-size: 10px;
  font-weight: $weight-bold;
  letter-spacing: 0.14em;
  color: $tape-washi-dark;
}

.partHe {
  font-family: $font-display;
  font-size: $text-sm;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
}

.partBody {
  margin: 0;
  font-family: $font-body;
  font-size: $text-base;
  line-height: $leading-body;
  color: $ink-blue;
}

// ── COPY ROW ───────────────────────────────────────────────────
.copyRow {
  display: flex;
  justify-content: flex-end;
}

.copyBtn {
  @include focus-ring;
  @include flex-start;
  gap: $space-2;
  padding: $space-2 $space-5;
  background: $ink-blue-dark;
  color: $paper-cream;
  border: 1.5px solid $ink-blue-dark;
  border-radius: $radius-full;
  font-family: $font-body;
  font-size: $text-sm;
  font-weight: $weight-bold;
  cursor: pointer;
  transition: all $dur-fast $ease-out;

  svg { font-size: 16px; }

  &:hover {
    background: $ink-blue;
    border-color: $ink-blue;
    transform: translateY(-1px);
    box-shadow: $shadow-lift;
  }
}

.copyBtnDone {
  background: $success;
  border-color: $success;

  &:hover { background: $success; border-color: $success; }
}
'@
Write-Source -Path 'src/components/LessonPlanCard/LessonPlanCard.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// LessonPlanCard — the 45-minute lesson plan that emerges from
// applying a move to a topic. Time blocks + brief description each.
// Reused by sections 3, 5, 6, 7.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbClipboardCheck } from 'react-icons/tb';
import styles from './LessonPlanCard.module.scss';

export interface LessonBlock {
  time: string;   // "0–5"
  name: string;   // "פתיח"
  body: string;
}

interface Props {
  totalMin: number;
  blocks: LessonBlock[];
  /** Optional title override; defaults to "השיעור שיצא לנו · 45 דק׳" */
  title?: string;
}

const LessonPlanCard: React.FC<Props> = ({ totalMin, blocks, title }) => (
  <section className={styles.card}>
    <header className={styles.head}>
      <span className={styles.icon} aria-hidden><TbClipboardCheck /></span>
      <div className={styles.titleBlock}>
        <span className={styles.eyebrow}>השיעור שיצא לנו</span>
        <h3 className={styles.title}>{title || `מערך שיעור · ${totalMin} דק׳`}</h3>
      </div>
    </header>

    <ol className={styles.blocks}>
      {blocks.map((b, i) => (
        <li key={i} className={styles.block}>
          <span className={styles.time}>{b.time}</span>
          <div className={styles.text}>
            <span className={styles.name}>{b.name}</span>
            <p className={styles.body}>{b.body}</p>
          </div>
        </li>
      ))}
    </ol>
  </section>
);

export default LessonPlanCard;
'@
Write-Source -Path 'src/components/LessonPlanCard/LessonPlanCard.module.scss' -Body @'
.card {
  @include paper-card;
  padding: $space-5;
  border-top: 4px solid $success;
}

// ── HEAD ───────────────────────────────────────────────────────
.head {
  @include flex-start;
  gap: $space-3;
  padding-bottom: $space-3;
  border-bottom: 1px dashed $paper-line;
  margin-bottom: $space-4;
}

.icon {
  @include flex-center;
  width: 44px; height: 44px;
  border-radius: 50%;
  background: $success-pale;
  color: $success;
  font-size: 22px;
}

.titleBlock { @include flex-col; gap: 2px; }

.eyebrow {
  font-family: $font-script;
  font-size: 18px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.title {
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin: 0;
}

// ── BLOCKS ─────────────────────────────────────────────────────
.blocks {
  list-style: none;
  margin: 0;
  padding: 0;
  @include flex-col;
  gap: $space-3;
}

.block {
  display: grid;
  grid-template-columns: 70px 1fr;
  gap: $space-3;
  padding: $space-2 0;
  border-bottom: 1px dotted $paper-line;

  &:last-child { border-bottom: none; }
}

.time {
  font-family: $font-mono;
  font-size: $text-sm;
  font-weight: $weight-bold;
  color: $red-pen;
  text-align: end;
  padding-top: 2px;
}

.text { @include flex-col; gap: 4px; }

.name {
  font-family: $font-display;
  font-size: $text-base;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
}

.body {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-body;
  color: $ink-blue;
}
'@
Write-Source -Path 'src/components/MoveReflection/MoveReflection.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// MoveReflection — closing card for each move-demo section.
// Single sticky-note style question prompting the teacher to think
// about where ELSE this move would be useful in their classroom.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbBulb } from 'react-icons/tb';
import styles from './MoveReflection.module.scss';

interface Props {
  question: string;
  hint?: string;
}

const MoveReflection: React.FC<Props> = ({ question, hint }) => (
  <aside className={styles.box}>
    <header className={styles.head}>
      <span className={styles.icon} aria-hidden><TbBulb /></span>
      <span className={styles.tag}>תחנת חשיבה</span>
    </header>
    <p className={styles.q}>{question}</p>
    {hint && <p className={styles.hint}>{hint}</p>}
  </aside>
);

export default MoveReflection;
'@
Write-Source -Path 'src/components/MoveReflection/MoveReflection.module.scss' -Body @'
.box {
  @include sticky-note($bg: $highlight-pale, $rotation: -1deg);
  padding: $space-4 $space-5;
  max-width: 540px;
  align-self: flex-start;
  @include flex-col;
  gap: $space-2;
}

.head {
  @include flex-start;
  gap: $space-2;
}

.icon {
  @include flex-center;
  width: 28px; height: 28px;
  border-radius: 50%;
  background: $highlight;
  color: $ink-blue-dark;
  font-size: 16px;
}

.tag {
  font-family: $font-mono;
  font-size: 10px;
  font-weight: $weight-bold;
  letter-spacing: 0.14em;
  color: $ink-blue-dark;
  text-transform: uppercase;
}

.q {
  margin: 0;
  font-family: $font-display;
  font-size: $text-md;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  line-height: $leading-body;
}

.hint {
  margin: 0;
  font-family: $font-script;
  font-size: $text-md;
  color: $ink-blue-soft;
}
'@
Write-Source -Path 'src/sections/02-theory/index.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// Section 02 — תיאוריה (Theory · 20 min)
// "שלושה מהלכים · מבט מהיר"
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import TheoryIntro from './TheoryIntro';
import MovesWorkbench from './MovesWorkbench';

const TheorySection: React.FC = () => (
  <SectionShell id="theory">
    <TheoryIntro />
    <MovesWorkbench />
  </SectionShell>
);

export default TheorySection;
'@
Write-Source -Path 'src/sections/02-theory/TheoryIntro.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// TheoryIntro — the framing card before the workbench.
// Explains the "moves" metaphor and the age-tier pairing logic.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import styles from './TheoryIntro.module.scss';

const TheoryIntro: React.FC = () => (
  <section className={styles.intro}>
    <span className={styles.tag}>מדריך מהיר</span>
    <h2 className={styles.title}>
      שלושה מהלכים. <span className={styles.hl}>שלוש דרכים</span> להפעיל AI.
    </h2>
    <p className={styles.lede}>
      כל מהלך הוא <strong>תבנית שימוש</strong> ב-AI לתכנון שיעור חינוך — לא ברירת מחדל. כל אחד
      מצטיין בגיל מסוים, אבל אפשר להשתמש בכולם בכל גיל. בחלקים הבאים נראה כל מהלך בפעולה ונפיק
      שיעור מוכן.
    </p>
  </section>
);

export default TheoryIntro;
'@
Write-Source -Path 'src/sections/02-theory/TheoryIntro.module.scss' -Body @'
.intro {
  @include flex-col;
  gap: $space-3;
}

.tag {
  font-family: $font-script;
  font-size: 22px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1.5deg);
  display: inline-block;
}

.title {
  font-family: $font-display;
  font-size: $text-xl;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  line-height: 1.15;
  margin: 0;

  @include respond-to(md) { font-size: $text-2xl; }
}

.hl {
  @include highlighter($highlight);
  color: $ink-blue-dark;
  font-weight: $weight-bold;
}

.lede {
  font-size: $text-md;
  line-height: $leading-loose;
  color: $ink-blue-soft;
  max-width: 640px;
  margin: 0;

  strong { color: $ink-blue-dark; font-weight: $weight-bold; }
}
'@
Write-Source -Path 'src/sections/02-theory/MovesWorkbench.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// MovesWorkbench — the 3 moves laid out like tools on a workbench.
// Each card is tilted at a slightly different angle for organic feel.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { MOVES } from '@/data/threeMoves';
import MoveCard from './MoveCard';
import styles from './MovesWorkbench.module.scss';

const ROTATIONS = ['-1.5deg', '1deg', '-0.8deg'];

const MovesWorkbench: React.FC = () => (
  <section className={styles.workbench} aria-label="שלושת המהלכים">
    <ul className={styles.grid}>
      {MOVES.map((m, i) => (
        <li
          key={m.id}
          className={styles.cell}
          style={{ '--rot': ROTATIONS[i % ROTATIONS.length] } as React.CSSProperties}
        >
          <MoveCard move={m} />
        </li>
      ))}
    </ul>
  </section>
);

export default MovesWorkbench;
'@
Write-Source -Path 'src/sections/02-theory/MovesWorkbench.module.scss' -Body @'
.workbench {
  margin-top: $space-3;
}

.grid {
  list-style: none;
  margin: 0;
  padding: $space-3 0;
  display: grid;
  gap: $space-5;
  grid-template-columns: 1fr;

  @include respond-to(md) {
    grid-template-columns: repeat(3, 1fr);
    gap: $space-4;
  }
}

.cell {
  transform: rotate(var(--rot, 0deg));
  transition: transform $dur-base $ease-out;

  @media (prefers-reduced-motion: reduce) {
    transform: none !important;
  }
}
'@
Write-Source -Path 'src/sections/02-theory/MoveCard.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// MoveCard — one of the three "tools" on the workbench.
// Visual: paper card with a tinted top band, number badge, age badge,
// move name, superpower line, and a before→after transform pill.
// Slight rotation for organic feel (driven by --rot CSS var from parent).
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbArrowLeft } from 'react-icons/tb';
import type { Move } from '@/data/threeMoves';
import styles from './MoveCard.module.scss';

interface Props {
  move: Move;
}

const MoveCard: React.FC<Props> = ({ move }) => (
  <article className={`${styles.card} ${styles[`tint-${move.tint}`]}`}>
    {/* TINTED TOP BAND with number + age */}
    <header className={styles.head}>
      <span className={styles.num}>{move.number}</span>
      <span className={styles.age} title={`מתאים במיוחד ל${move.bestFor.label}`}>
        <span className={styles.ageEmoji} aria-hidden>{move.bestFor.emoji}</span>
        {move.bestFor.label}
      </span>
    </header>

    {/* BODY */}
    <div className={styles.body}>
      <h3 className={styles.name}>
        {move.nameHe}
        <span className={styles.nameEn}>{move.nameEn}</span>
      </h3>

      <p className={styles.superpower}>{move.superpower}</p>

      <p className={styles.description}>{move.description}</p>

      {/* TRANSFORM PILL */}
      <div className={styles.transform} aria-label="התמורה שהמהלך מייצר">
        <span className={styles.transformFrom}>{move.transform.from}</span>
        <TbArrowLeft aria-hidden className={styles.transformArrow} />
        <span className={styles.transformTo}>{move.transform.to}</span>
      </div>

      {/* DEMO TEASER */}
      <footer className={styles.foot}>
        <span className={styles.footLabel}>נראה בפעולה על</span>
        <span className={styles.footTopic}>{move.demoTopic}</span>
      </footer>
    </div>
  </article>
);

export default MoveCard;
'@
Write-Source -Path 'src/sections/02-theory/MoveCard.module.scss' -Body @'
.card {
  @include paper-card;
  @include flex-col;
  overflow: hidden;
  transition: transform $dur-base $ease-out, box-shadow $dur-base $ease-out;

  &:hover {
    transform: rotate(0) translateY(-4px) !important;
    box-shadow: $shadow-lift;
  }
}

// ── HEAD (tinted band) ─────────────────────────────────────────
.head {
  @include flex-between;
  padding: $space-3 $space-4;
  background: $highlight-pale;
}

.tint-yellow .head { background: $highlight-pale; }
.tint-blue   .head { background: rgba(168, 200, 218, 0.4); }
.tint-red    .head { background: $red-pen-pale; }

.num {
  @include flex-center;
  width: 32px; height: 32px;
  border-radius: 50%;
  background: $ink-blue-dark;
  color: $paper-cream;
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
}

.age {
  @include flex-start;
  gap: $space-1;
  font-family: $font-script;
  font-size: 20px;
  color: $ink-blue-dark;
  font-weight: $weight-bold;
}

.ageEmoji { font-size: 18px; }

// ── BODY ───────────────────────────────────────────────────────
.body {
  @include flex-col;
  gap: $space-3;
  padding: $space-4 $space-4 $space-3;
}

.name {
  @include flex-col;
  gap: 2px;
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin: 0;
  line-height: 1.1;
}

.nameEn {
  font-family: $font-script;
  font-size: $text-md;
  color: $red-pen;
  font-weight: $weight-medium;
  letter-spacing: 0.02em;
}

.superpower {
  font-size: $text-base;
  color: $ink-blue-dark;
  font-weight: $weight-medium;
  line-height: $leading-body;
  margin: 0;
}

.description {
  font-size: $text-sm;
  color: $ink-blue-soft;
  line-height: $leading-loose;
  margin: 0;
}

// ── TRANSFORM PILL ─────────────────────────────────────────────
.transform {
  @include flex-start;
  gap: $space-2;
  padding: $space-2 $space-3;
  background: $paper-cream-2;
  border-radius: $radius-full;
  font-family: $font-mono;
  font-size: $text-xs;
  font-weight: $weight-medium;
  color: $ink-blue-soft;
  align-self: flex-start;
}

.transformFrom { color: $ink-blue-soft; text-decoration: line-through; }
.transformTo   { color: $red-pen; font-weight: $weight-bold; }
.transformArrow { font-size: 14px; color: $pencil-light; }

// ── FOOTER ─────────────────────────────────────────────────────
.foot {
  @include flex-col;
  gap: 2px;
  margin-top: $space-2;
  padding-top: $space-3;
  border-top: 1px dashed $paper-line;
}

.footLabel {
  font-family: $font-script;
  font-size: $text-md;
  color: $red-pen;
  transform: rotate(-1deg);
  display: inline-block;
}

.footTopic {
  font-family: $font-body;
  font-size: $text-sm;
  color: $ink-blue-dark;
  font-weight: $weight-medium;
}
'@
Write-Source -Path 'src/sections/03-scenarios/index.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// Section 03 — מהלך 1 · מחולל תרחישים · יסודי (25 min)
// Walks the teacher through: the move's superpower → the 4-part prompt
// → the AI output (3 stories + activity) → the 45-min lesson plan
// → a reflection on where else this move helps.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import MoveDemoIntro from '@/components/MoveDemoIntro/MoveDemoIntro';
import PromptDemo from '@/components/PromptDemo/PromptDemo';
import LessonPlanCard from '@/components/LessonPlanCard/LessonPlanCard';
import MoveReflection from '@/components/MoveReflection/MoveReflection';
import { MOVE_BY_ID } from '@/data/threeMoves';
import { SCENARIO_DEMO } from '@/data/moveDemos';
import ScenariosOutput from './ScenariosOutput';

const ScenariosSection: React.FC = () => {
  const move = MOVE_BY_ID.scenarios;
  return (
    <SectionShell id="scenarios">
      <MoveDemoIntro
        move={move}
        demoTopic={SCENARIO_DEMO.topic}
        gradeLabel={SCENARIO_DEMO.grade}
      />

      <PromptDemo prompt={SCENARIO_DEMO.prompt} />

      <ScenariosOutput />

      <LessonPlanCard
        totalMin={SCENARIO_DEMO.plan.totalMin}
        blocks={SCENARIO_DEMO.plan.blocks}
      />

      <MoveReflection
        question='איפה עוד במחזור החיים של הכיתה שלכם — מחולל תרחישים יעזור?'
        hint='לדוגמה: אנטי־בלינג, יום הזיכרון, פתיחת שנה, חזרה אחרי הפסקה ארוכה.'
      />
    </SectionShell>
  );
};

export default ScenariosSection;
'@
Write-Source -Path 'src/sections/03-scenarios/ScenariosOutput.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// ScenariosOutput — the AI's response for Move 1.
// Three story cards (one per scenario) + closing activity card.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbMessageCircle, TbActivity } from 'react-icons/tb';
import { SCENARIO_DEMO } from '@/data/moveDemos';
import styles from './ScenariosOutput.module.scss';

// Discussion questions per story — same 4 per story (the prompt format
// asks for 4 per story; we keep one shared set for now since the workshop
// emphasizes the move pattern, not story-specific questions).
const DISCUSSION_QUESTIONS = [
  'מה הילד מרגיש לדעתכם? מה הסימנים שאפשר לראות מבחוץ?',
  'מי בכיתה כבר עבר משהו דומה? (בלי לציין שמות)',
  'מה היה עוזר לו ביום הראשון? מי היה צריך לעשות מהלך?',
  'אם זה היה עומק על מה שאתם רואים בכיתה — מה היינו עושים אחרת?',
];

const ScenariosOutput: React.FC = () => (
  <section className={styles.section}>
    <header className={styles.head}>
      <span className={styles.tag}>הפלט של ה-AI</span>
      <h3 className={styles.title}>3 סיפורים. אותו נושא, סיבות שונות.</h3>
      <p className={styles.lede}>
        ה-AI לא יודע את הילדים שלכם — אבל הוא מייצר סיפורים גנריים מספיק שהילדים יכולים
        להזדהות, וספציפיים מספיק שהם לא ירגישו "לימודיים".
      </p>
    </header>

    {/* STORIES */}
    <div className={styles.stories}>
      {SCENARIO_DEMO.stories.map((s, i) => (
        <article key={i} className={styles.story}>
          <header className={styles.storyHead}>
            <span className={styles.storyNum}>סיפור {i + 1}</span>
            <h4 className={styles.storyName}>{s.name}</h4>
            <span className={styles.storyCause}>{s.cause}</span>
          </header>
          <p className={styles.storyBody}>{s.preview}</p>
        </article>
      ))}
    </div>

    {/* DISCUSSION QUESTIONS — shared block */}
    <aside className={styles.discussion}>
      <header className={styles.discussionHead}>
        <TbMessageCircle aria-hidden />
        <h4>שאלות לדיון אחרי כל סיפור</h4>
      </header>
      <ol className={styles.qList}>
        {DISCUSSION_QUESTIONS.map((q, i) => (
          <li key={i}>{q}</li>
        ))}
      </ol>
    </aside>

    {/* ACTIVITY */}
    <aside className={styles.activity}>
      <header className={styles.activityHead}>
        <TbActivity aria-hidden />
        <div>
          <span className={styles.activityTag}>פעילות סיכום</span>
          <h4>{SCENARIO_DEMO.activity.name}</h4>
        </div>
        <span className={styles.activityTime}>{SCENARIO_DEMO.activity.duration}</span>
      </header>
      <ol className={styles.stepList}>
        {SCENARIO_DEMO.activity.steps.map((s, i) => (
          <li key={i}>{s}</li>
        ))}
      </ol>
    </aside>
  </section>
);

export default ScenariosOutput;
'@
Write-Source -Path 'src/sections/03-scenarios/ScenariosOutput.module.scss' -Body @'
.section { @include flex-col; gap: $space-4; }

// ── HEAD ───────────────────────────────────────────────────────
.head { @include flex-col; gap: $space-1; }

.tag {
  font-family: $font-script;
  font-size: 22px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.title {
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin: 0;

  @include respond-to(md) { font-size: $text-xl; }
}

.lede {
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue-soft;
  margin: 0;
  max-width: 640px;
}

// ── STORIES ────────────────────────────────────────────────────
.stories {
  display: grid;
  gap: $space-4;
  grid-template-columns: 1fr;

  @include respond-to(md) { grid-template-columns: repeat(3, 1fr); }
}

.story {
  @include paper-card;
  padding: $space-4;
  border-top: 3px solid $highlight-dark;
  @include flex-col;
  gap: $space-2;
}

.storyHead {
  @include flex-col;
  gap: 2px;
  padding-bottom: $space-2;
  border-bottom: 1px dashed $paper-line;
}

.storyNum {
  font-family: $font-mono;
  font-size: 10px;
  letter-spacing: 0.14em;
  color: $ink-blue-soft;
  text-transform: uppercase;
}

.storyName {
  margin: 0;
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
}

.storyCause {
  font-family: $font-script;
  font-size: $text-md;
  color: $red-pen;
  font-weight: $weight-medium;
}

.storyBody {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue;
}

// ── DISCUSSION ─────────────────────────────────────────────────
.discussion {
  @include paper-card;
  padding: $space-4 $space-5;
  border-inline-start: 4px solid $tape-washi-dark;
}

.discussionHead {
  @include flex-start;
  gap: $space-2;
  margin-bottom: $space-3;

  svg { font-size: 20px; color: $tape-washi-dark; }

  h4 {
    margin: 0;
    font-family: $font-display;
    font-size: $text-md;
    font-weight: $weight-bold;
    color: $ink-blue-dark;
  }
}

.qList {
  margin: 0;
  padding-inline-start: $space-5;
  @include flex-col;
  gap: $space-2;

  li {
    font-size: $text-sm;
    line-height: $leading-loose;
    color: $ink-blue;
  }
}

// ── ACTIVITY ───────────────────────────────────────────────────
.activity {
  @include paper-card;
  padding: $space-4 $space-5;
  border-inline-start: 4px solid $success;
  background: rgba(74, 143, 63, 0.04);
}

.activityHead {
  @include flex-start;
  gap: $space-3;
  margin-bottom: $space-3;
  padding-bottom: $space-2;
  border-bottom: 1px dashed $paper-line;

  > svg { font-size: 20px; color: $success; }

  > div { flex: 1; @include flex-col; gap: 0; }

  h4 {
    margin: 0;
    font-family: $font-display;
    font-size: $text-md;
    font-weight: $weight-bold;
    color: $ink-blue-dark;
  }
}

.activityTag {
  font-family: $font-mono;
  font-size: 10px;
  letter-spacing: 0.14em;
  color: $success;
  text-transform: uppercase;
}

.activityTime {
  font-family: $font-mono;
  font-size: $text-sm;
  font-weight: $weight-bold;
  color: $success;
}

.stepList {
  margin: 0;
  padding-inline-start: $space-5;
  @include flex-col;
  gap: $space-2;

  li {
    font-size: $text-sm;
    line-height: $leading-loose;
    color: $ink-blue;
  }
}
'@
Write-Source -Path 'src/sections/04-break/index.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// Section 04 — הפסקה · בחירת הכיתה (15 min)
// Two purposes:
//   (1) Mid-workshop pause (water, stretch).
//   (2) Teacher fills in their REAL class for the personal lesson
//       (used in Section 7).
// Next button is gated on the class-picker being valid.
// ═══════════════════════════════════════════════════════════════════
import React, { useState } from 'react';
import { TbCoffee } from 'react-icons/tb';
import SectionShell from '@/components/SectionShell/SectionShell';
import ClassPicker from './ClassPicker';
import styles from './index.module.scss';

const BreakSection: React.FC = () => {
  const [valid, setValid] = useState(false);

  return (
    <SectionShell id="break" canAdvance={valid}>
      <aside className={styles.banner}>
        <span className={styles.icon} aria-hidden><TbCoffee /></span>
        <div>
          <h2 className={styles.title}>הפסקה של 10 דקות</h2>
          <p className={styles.lede}>
            קחו אוויר, מים, מתיחה. וכשתחזרו — תמלאו את הטופס למטה.
            השיעור האחרון (חלק 7) ייבנה על הכיתה האמיתית שלכם.
          </p>
        </div>
      </aside>

      <ClassPicker onValidityChange={setValid} />
    </SectionShell>
  );
};

export default BreakSection;
'@
Write-Source -Path 'src/sections/04-break/index.module.scss' -Body @'
.banner {
  @include flex-start;
  gap: $space-4;
  padding: $space-5;
  background: $highlight-pale;
  border-radius: $radius-md;
  border-inline-start: 4px solid $highlight-dark;

  > div { flex: 1; @include flex-col; gap: $space-1; }
}

.icon {
  @include flex-center;
  width: 56px; height: 56px;
  border-radius: 50%;
  background: $highlight;
  color: $ink-blue-dark;
  font-size: 28px;
  flex-shrink: 0;
}

.title {
  font-family: $font-display;
  font-size: $text-xl;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin: 0;
}

.lede {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue;
}
'@
Write-Source -Path 'src/sections/04-break/ClassPicker.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// ClassPicker — form filled during Break section.
// Teacher enters: subject, grade, age tier, topic for their personal
// lesson. Stored in ModuleProgress.customTopic via context.
// canAdvance gate fires once all required fields are filled.
// ═══════════════════════════════════════════════════════════════════
import React, { useEffect, useState } from 'react';
import { TbSchool } from 'react-icons/tb';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import type { CustomTopic, AgeTier } from '@/types/module.types';
import styles from './ClassPicker.module.scss';

const AGE_OPTIONS: { value: AgeTier; label: string; emoji: string; gradeHint: string }[] = [
  { value: 'elementary', label: 'יסודי',  emoji: '🎒', gradeHint: 'א׳–ו׳' },
  { value: 'middle',     label: 'חט״ב',   emoji: '📱', gradeHint: 'ז׳–ט׳' },
  { value: 'high',       label: 'תיכון', emoji: '🎓', gradeHint: 'י׳–יב׳' },
];

interface Props {
  onValidityChange: (valid: boolean) => void;
}

const ClassPicker: React.FC<Props> = ({ onValidityChange }) => {
  const { progress, setCustomTopic } = useProgressCtx();
  const saved = progress.customTopic;

  const [subject, setSubject]   = useState(saved?.subject  ?? 'חינוך');
  const [grade,   setGrade]     = useState(saved?.grade    ?? '');
  const [ageTier, setAgeTier]   = useState<AgeTier | ''>(saved?.ageTier ?? '');
  const [topic,   setTopic]     = useState(saved?.topic    ?? '');
  const [context, setContext]   = useState(saved?.context  ?? '');

  // Validity & persistence
  useEffect(() => {
    const valid = !!(subject.trim() && grade.trim() && ageTier && topic.trim());
    onValidityChange(valid);
    if (valid) {
      const t: CustomTopic = {
        subject: subject.trim(),
        grade:   grade.trim(),
        ageTier: ageTier as AgeTier,
        topic:   topic.trim(),
        context: context.trim() || undefined,
      };
      setCustomTopic(t);
    }
  }, [subject, grade, ageTier, topic, context, onValidityChange, setCustomTopic]);

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.icon} aria-hidden><TbSchool /></span>
        <div>
          <span className={styles.tag}>הכיתה שלכם</span>
          <h3 className={styles.title}>איזה שיעור חינוך אתם בונים בשבוע הבא?</h3>
          <p className={styles.lede}>
            בחלק 7 (השיעור שלכם) — נשתמש בכיתה הזאת. אפשר תמיד לחזור ולערוך.
          </p>
        </div>
      </header>

      <div className={styles.fields}>
        <label className={styles.field}>
          <span className={styles.label}>מקצוע</span>
          <input
            type="text"
            value={subject}
            onChange={e => setSubject(e.target.value)}
            placeholder="חינוך"
            className={styles.input}
          />
        </label>

        <label className={styles.field}>
          <span className={styles.label}>כיתה</span>
          <input
            type="text"
            value={grade}
            onChange={e => setGrade(e.target.value)}
            placeholder='ז׳1 / ד׳ / יא׳ ...'
            className={styles.input}
          />
        </label>

        <fieldset className={styles.fieldset}>
          <legend className={styles.label}>שכבת גיל</legend>
          <div className={styles.ageRow}>
            {AGE_OPTIONS.map(opt => (
              <label
                key={opt.value}
                className={`${styles.ageOption} ${ageTier === opt.value ? styles.ageOptionActive : ''}`}
              >
                <input
                  type="radio"
                  name="ageTier"
                  value={opt.value}
                  checked={ageTier === opt.value}
                  onChange={() => setAgeTier(opt.value)}
                  className={styles.ageRadio}
                />
                <span className={styles.ageEmoji} aria-hidden>{opt.emoji}</span>
                <span className={styles.ageLabel}>{opt.label}</span>
                <span className={styles.ageHint}>{opt.gradeHint}</span>
              </label>
            ))}
          </div>
        </fieldset>

        <label className={styles.field}>
          <span className={styles.label}>נושא לשיעור</span>
          <input
            type="text"
            value={topic}
            onChange={e => setTopic(e.target.value)}
            placeholder='לדוג׳: תקרית בקבוצה / פתיחת שנה / יום השואה / בחירת מסלול'
            className={styles.input}
          />
        </label>

        <label className={styles.field}>
          <span className={styles.label}>הקשר נוסף <span className={styles.opt}>(אופציונלי)</span></span>
          <textarea
            value={context}
            onChange={e => setContext(e.target.value)}
            placeholder='מה כדאי שה-AI יידע על הכיתה? לדוגמה: רוב הבנות, כיתה רועשת, אחרי תקרית.'
            rows={3}
            className={styles.textarea}
          />
        </label>
      </div>
    </section>
  );
};

export default ClassPicker;
'@
Write-Source -Path 'src/sections/04-break/ClassPicker.module.scss' -Body @'
.section { @include flex-col; gap: $space-5; }

// ── HEAD ───────────────────────────────────────────────────────
.head {
  @include flex-start;
  gap: $space-4;
  align-items: flex-start;

  > div { flex: 1; @include flex-col; gap: $space-1; }
}

.icon {
  @include flex-center;
  width: 56px; height: 56px;
  border-radius: 50%;
  background: $highlight-pale;
  color: $highlight-dark;
  font-size: 28px;
  flex-shrink: 0;
}

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
  margin: 0;
  line-height: 1.15;
}

.lede {
  margin: 0;
  font-size: $text-sm;
  color: $ink-blue-soft;
  line-height: $leading-loose;
}

// ── FIELDS ─────────────────────────────────────────────────────
.fields {
  @include flex-col;
  gap: $space-4;
  padding: $space-5;
  background: $paper-cream;
  border-radius: $radius-md;
  box-shadow: $shadow-paper;
}

.field { @include flex-col; gap: $space-1; }
.fieldset { border: none; padding: 0; margin: 0; @include flex-col; gap: $space-2; }

.label {
  font-family: $font-display;
  font-size: $text-sm;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
}

.opt {
  font-family: $font-body;
  font-size: $text-xs;
  font-weight: $weight-normal;
  color: $ink-blue-soft;
}

.input,
.textarea {
  font-family: $font-body;
  font-size: $text-base;
  line-height: $leading-body;
  color: $ink-blue-dark;
  background: $white;
  border: 1.5px solid $paper-line;
  border-radius: $radius-md;
  padding: $space-2 $space-3;
  transition: all $dur-fast $ease-out;

  &::placeholder { color: $pencil-light; }

  &:focus {
    outline: none;
    border-color: $red-pen;
    box-shadow: 0 0 0 3px rgba($red-pen, 0.12);
  }
}

.textarea { resize: vertical; min-height: 70px; }

// ── AGE TIER RADIO GROUP ───────────────────────────────────────
.ageRow {
  display: grid;
  grid-template-columns: 1fr;
  gap: $space-2;

  @include respond-to(md) { grid-template-columns: repeat(3, 1fr); }
}

.ageOption {
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: $space-2;
  padding: $space-3 $space-4;
  background: $white;
  border: 1.5px solid $paper-line;
  border-radius: $radius-md;
  cursor: pointer;
  transition: all $dur-fast $ease-out;

  &:hover { border-color: $pencil; }
}

.ageOptionActive {
  border-color: $red-pen !important;
  background: $red-pen-pale !important;
}

.ageRadio {
  position: absolute;
  opacity: 0;
  width: 1px; height: 1px;
}

.ageEmoji { font-size: 22px; }

.ageLabel {
  font-family: $font-display;
  font-size: $text-md;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
}

.ageHint {
  font-family: $font-mono;
  font-size: $text-xs;
  color: $ink-blue-soft;
}
'@
Write-Source -Path 'src/sections/05-voices/index.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// Section 05 — מהלך 2 · שלוש קולות · חט״ב (25 min)
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import MoveDemoIntro from '@/components/MoveDemoIntro/MoveDemoIntro';
import PromptDemo from '@/components/PromptDemo/PromptDemo';
import LessonPlanCard from '@/components/LessonPlanCard/LessonPlanCard';
import MoveReflection from '@/components/MoveReflection/MoveReflection';
import { MOVE_BY_ID } from '@/data/threeMoves';
import { VOICES_DEMO } from '@/data/moveDemos';
import VoicesOutput from './VoicesOutput';

const VoicesSection: React.FC = () => {
  const move = MOVE_BY_ID.voices;
  return (
    <SectionShell id="voices">
      <MoveDemoIntro
        move={move}
        demoTopic={VOICES_DEMO.topic}
        gradeLabel={VOICES_DEMO.grade}
      />

      <PromptDemo prompt={VOICES_DEMO.prompt} />

      <VoicesOutput />

      <LessonPlanCard
        totalMin={VOICES_DEMO.plan.totalMin}
        blocks={VOICES_DEMO.plan.blocks}
      />

      <MoveReflection
        question='איזה אירוע בכיתה שלכם השנה היה צריך "שלוש קולות"?'
        hint='לדוגמה: ביקורת על מורה, ויכוח על ציון, הקנטה שלא הוכרה בזמן.'
      />
    </SectionShell>
  );
};

export default VoicesSection;
'@
Write-Source -Path 'src/sections/05-voices/VoicesOutput.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// VoicesOutput — AI's response for Move 2 (Three Voices).
// Three voice cards laid out vertically (each a different speaker)
// + the 4-corners discussion protocol card.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbCornerDownLeft, TbUsers } from 'react-icons/tb';
import { VOICES_DEMO } from '@/data/moveDemos';
import styles from './VoicesOutput.module.scss';

const VoicesOutput: React.FC = () => (
  <section className={styles.section}>
    <header className={styles.head}>
      <span className={styles.tag}>הפלט של ה-AI</span>
      <h3 className={styles.title}>אותו אירוע. שלוש זוויות.</h3>
      <p className={styles.lede}>
        AI לא מציע "נכון" או "לא נכון" — הוא מציג את אותו הסיפור משלוש פרספקטיבות. התלמידים
        שומעים מה הקול שהם לא היו חושבים עליו לבד.
      </p>
    </header>

    {/* THREE VOICES */}
    <div className={styles.voices}>
      {VOICES_DEMO.voices.map((v, i) => (
        <article key={i} className={styles.voice}>
          <header className={styles.voiceHead}>
            <span className={styles.voiceNum}>קול {i + 1}</span>
            <h4 className={styles.voiceWho}>{v.who}</h4>
            <span className={styles.voicePerspective}>{v.perspective}</span>
          </header>
          <blockquote className={styles.voiceBody}>{v.preview}</blockquote>
        </article>
      ))}
    </div>

    {/* 4 CORNERS PROTOCOL */}
    <aside className={styles.protocol}>
      <header className={styles.protocolHead}>
        <TbUsers aria-hidden />
        <div>
          <span className={styles.protocolTag}>פרוטוקול דיון</span>
          <h4>{VOICES_DEMO.protocol.name}</h4>
        </div>
        <span className={styles.protocolTime}>{VOICES_DEMO.protocol.duration}</span>
      </header>

      <p className={styles.protocolDesc}>{VOICES_DEMO.protocol.description}</p>

      <ul className={styles.corners}>
        {VOICES_DEMO.protocol.corners.map((c, i) => (
          <li key={i} className={styles.corner}>
            <span className={styles.cornerLabel}>
              <TbCornerDownLeft aria-hidden /> {c.label}
            </span>
            <p className={styles.cornerQ}>{c.q}</p>
          </li>
        ))}
      </ul>
    </aside>
  </section>
);

export default VoicesOutput;
'@
Write-Source -Path 'src/sections/05-voices/VoicesOutput.module.scss' -Body @'
.section { @include flex-col; gap: $space-4; }

// ── HEAD ───────────────────────────────────────────────────────
.head { @include flex-col; gap: $space-1; }

.tag {
  font-family: $font-script;
  font-size: 22px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.title {
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin: 0;

  @include respond-to(md) { font-size: $text-xl; }
}

.lede {
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue-soft;
  margin: 0;
  max-width: 640px;
}

// ── VOICES ─────────────────────────────────────────────────────
.voices {
  @include flex-col;
  gap: $space-3;
}

.voice {
  @include paper-card;
  padding: $space-4 $space-5;
  border-inline-start: 4px solid $tape-washi-dark;
  position: relative;
}

.voice:nth-child(1) { border-inline-start-color: $tape-washi-dark; }
.voice:nth-child(2) { border-inline-start-color: $highlight-dark; }
.voice:nth-child(3) { border-inline-start-color: $red-pen; }

.voiceHead {
  @include flex-start;
  gap: $space-3;
  padding-bottom: $space-2;
  border-bottom: 1px dashed $paper-line;
  margin-bottom: $space-3;
  flex-wrap: wrap;
}

.voiceNum {
  font-family: $font-mono;
  font-size: 10px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: $ink-blue-soft;
}

.voiceWho {
  margin: 0;
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
}

.voicePerspective {
  font-family: $font-script;
  font-size: $text-md;
  color: $red-pen;
  font-weight: $weight-medium;
}

.voiceBody {
  margin: 0;
  font-family: $font-body;
  font-size: $text-base;
  line-height: $leading-loose;
  color: $ink-blue;
  font-style: italic;
}

// ── PROTOCOL ───────────────────────────────────────────────────
.protocol {
  @include paper-card;
  padding: $space-4 $space-5;
  border-inline-start: 4px solid $success;
  background: rgba(74, 143, 63, 0.04);
}

.protocolHead {
  @include flex-start;
  gap: $space-3;
  padding-bottom: $space-2;
  border-bottom: 1px dashed $paper-line;
  margin-bottom: $space-3;

  > svg { font-size: 20px; color: $success; }
  > div { flex: 1; @include flex-col; }

  h4 {
    margin: 0;
    font-family: $font-display;
    font-size: $text-md;
    font-weight: $weight-bold;
    color: $ink-blue-dark;
  }
}

.protocolTag {
  font-family: $font-mono;
  font-size: 10px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: $success;
}

.protocolTime {
  font-family: $font-mono;
  font-size: $text-sm;
  font-weight: $weight-bold;
  color: $success;
}

.protocolDesc {
  margin: 0 0 $space-3;
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue;
}

.corners {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: $space-3;
  grid-template-columns: 1fr;

  @include respond-to(md) { grid-template-columns: 1fr 1fr; }
}

.corner {
  padding: $space-3 $space-4;
  background: $paper-cream-2;
  border-radius: $radius-md;
  border: 1px solid $paper-line;
}

.cornerLabel {
  @include flex-start;
  gap: $space-1;
  font-family: $font-display;
  font-size: $text-base;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin-bottom: $space-1;

  svg { font-size: 16px; color: $red-pen; }
}

.cornerQ {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue;
}
'@
Write-Source -Path 'src/sections/06-case/index.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// Section 06 — מהלך 3 · מהמקרה אל הערך · תיכון (25 min)
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import MoveDemoIntro from '@/components/MoveDemoIntro/MoveDemoIntro';
import PromptDemo from '@/components/PromptDemo/PromptDemo';
import LessonPlanCard from '@/components/LessonPlanCard/LessonPlanCard';
import MoveReflection from '@/components/MoveReflection/MoveReflection';
import { MOVE_BY_ID } from '@/data/threeMoves';
import { CASE_DEMO } from '@/data/moveDemos';
import CaseOutput from './CaseOutput';

const CaseSection: React.FC = () => {
  const move = MOVE_BY_ID.case;
  return (
    <SectionShell id="case">
      <MoveDemoIntro
        move={move}
        demoTopic={CASE_DEMO.topic}
        gradeLabel={CASE_DEMO.grade}
      />

      <PromptDemo prompt={CASE_DEMO.prompt} />

      <CaseOutput />

      <LessonPlanCard
        totalMin={CASE_DEMO.plan.totalMin}
        blocks={CASE_DEMO.plan.blocks}
      />

      <MoveReflection
        question='איזה דילמה אצלכם בכיתה דורשת "מהמקרה אל הערך" — שיעור עם עומק, בלי תשובה אחת?'
        hint='לדוגמה: גיוס לפלוגות שונות, יחס למחויבות אזרחית, בחירת מסלולים אחרי שמינית.'
      />
    </SectionShell>
  );
};

export default CaseSection;
'@
Write-Source -Path 'src/sections/06-case/CaseOutput.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// CaseOutput — AI's response for Move 3 (Backwards from Case).
// 5 case cards + 12-value sort + 3 closing questions.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbCards, TbMessageQuestion } from 'react-icons/tb';
import { CASE_DEMO } from '@/data/moveDemos';
import styles from './CaseOutput.module.scss';

const CaseOutput: React.FC = () => (
  <section className={styles.section}>
    <header className={styles.head}>
      <span className={styles.tag}>הפלט של ה-AI</span>
      <h3 className={styles.title}>5 מקרים אמיתיים. 12 ערכים. שאלה אחת אישית.</h3>
      <p className={styles.lede}>
        אין "מסלול נכון" — יש <strong>ערכים</strong> שמובילים לבחירה. ה-AI לוקח 5 מקרים שונים,
        חולץ מהם את הערכים מתחת לפני השטח, ומציע פעילות שעוזרת לתלמיד לזהות אילו ערכים מובילים אותו.
      </p>
    </header>

    {/* 5 CASES */}
    <div className={styles.cases}>
      {CASE_DEMO.cases.map((c, i) => (
        <article key={i} className={styles.case}>
          <header className={styles.caseHead}>
            <span className={styles.caseNum}>מקרה {i + 1}</span>
            <h4 className={styles.casePath}>{c.path}</h4>
          </header>
          <p className={styles.caseOutcome}>{c.outcome}</p>
        </article>
      ))}
    </div>

    {/* VALUE CARDS */}
    <aside className={styles.values}>
      <header className={styles.valuesHead}>
        <TbCards aria-hidden />
        <div>
          <span className={styles.valuesTag}>פעילות · קלפי ערכים</span>
          <h4>12 ערכים — לסדר מהכי חשוב לפחות</h4>
        </div>
      </header>
      <ul className={styles.valueGrid} aria-label="ערכים מוצעים">
        {CASE_DEMO.values.map((v, i) => (
          <li key={i} className={styles.valueCard}>{v}</li>
        ))}
      </ul>
    </aside>

    {/* CLOSING QUESTIONS */}
    <aside className={styles.questions}>
      <header className={styles.questionsHead}>
        <TbMessageQuestion aria-hidden />
        <h4>3 שאלות סיכום</h4>
      </header>
      <ol className={styles.qList}>
        {CASE_DEMO.closingQuestions.map((q, i) => (
          <li key={i}>{q}</li>
        ))}
      </ol>
    </aside>
  </section>
);

export default CaseOutput;
'@
Write-Source -Path 'src/sections/06-case/CaseOutput.module.scss' -Body @'
.section { @include flex-col; gap: $space-4; }

// ── HEAD ───────────────────────────────────────────────────────
.head { @include flex-col; gap: $space-1; }

.tag {
  font-family: $font-script;
  font-size: 22px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.title {
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin: 0;

  @include respond-to(md) { font-size: $text-xl; }
}

.lede {
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue-soft;
  margin: 0;
  max-width: 640px;

  strong { color: $red-pen; font-weight: $weight-bold; }
}

// ── CASES ──────────────────────────────────────────────────────
.cases {
  display: grid;
  gap: $space-3;
  grid-template-columns: 1fr;

  @include respond-to(md) { grid-template-columns: 1fr 1fr; }
}

.case {
  @include paper-card;
  padding: $space-3 $space-4;
  border-top: 3px solid $red-pen;
}

.caseHead {
  @include flex-start;
  gap: $space-3;
  margin-bottom: $space-2;
  padding-bottom: $space-2;
  border-bottom: 1px dashed $paper-line;
  flex-wrap: wrap;
}

.caseNum {
  font-family: $font-mono;
  font-size: 10px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: $red-pen;
}

.casePath {
  margin: 0;
  font-family: $font-display;
  font-size: $text-md;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
}

.caseOutcome {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue;
}

// ── VALUES ─────────────────────────────────────────────────────
.values {
  @include paper-card;
  padding: $space-4 $space-5;
  border-inline-start: 4px solid $highlight-dark;
  background: rgba(244, 213, 90, 0.06);
}

.valuesHead {
  @include flex-start;
  gap: $space-3;
  padding-bottom: $space-2;
  border-bottom: 1px dashed $paper-line;
  margin-bottom: $space-3;

  > svg { font-size: 20px; color: $highlight-dark; }
  > div { flex: 1; @include flex-col; }

  h4 {
    margin: 0;
    font-family: $font-display;
    font-size: $text-md;
    font-weight: $weight-bold;
    color: $ink-blue-dark;
  }
}

.valuesTag {
  font-family: $font-mono;
  font-size: 10px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: $highlight-dark;
}

.valueGrid {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: $space-2;
  grid-template-columns: repeat(2, 1fr);

  @include respond-to(sm) { grid-template-columns: repeat(3, 1fr); }
  @include respond-to(md) { grid-template-columns: repeat(4, 1fr); }
}

.valueCard {
  padding: $space-2 $space-3;
  background: $paper-cream;
  border: 1.5px solid $highlight-dark;
  border-radius: $radius-md;
  font-family: $font-display;
  font-size: $text-sm;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  text-align: center;
  transform: rotate(-0.5deg);
  transition: transform $dur-fast $ease-out;

  &:hover { transform: rotate(0) translateY(-2px); box-shadow: $shadow-paper; }
  &:nth-child(3n+2) { transform: rotate(0.8deg); }
  &:nth-child(5n+3) { transform: rotate(-1deg); }
}

// ── CLOSING QUESTIONS ──────────────────────────────────────────
.questions {
  @include paper-card;
  padding: $space-4 $space-5;
  border-inline-start: 4px solid $success;
}

.questionsHead {
  @include flex-start;
  gap: $space-2;
  padding-bottom: $space-2;
  border-bottom: 1px dashed $paper-line;
  margin-bottom: $space-3;

  svg { font-size: 20px; color: $success; }

  h4 {
    margin: 0;
    font-family: $font-display;
    font-size: $text-md;
    font-weight: $weight-bold;
    color: $ink-blue-dark;
  }
}

.qList {
  margin: 0;
  padding-inline-start: $space-5;
  @include flex-col;
  gap: $space-2;

  li {
    font-size: $text-sm;
    line-height: $leading-loose;
    color: $ink-blue;
  }
}
'@
Write-Source -Path 'src/sections/07-personal/index.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// Section 07 — השיעור שלך · מהלך אחד · הכיתה שלך (30 min)
// Three parts:
//   1. Pick a move (MoveSelector)
//   2. See the personalized 4-part prompt (PersonalPromptBuilder)
//   3. Run it in AI and capture what you got (PersonalNotes)
// Next button gated on having selected a move.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import MoveSelector from './MoveSelector';
import PersonalPromptBuilder from './PersonalPromptBuilder';
import PersonalNotes from './PersonalNotes';

const PersonalSection: React.FC = () => {
  const { progress } = useProgressCtx();
  const canAdvance = progress.personalMove !== null;

  return (
    <SectionShell id="personal" canAdvance={canAdvance}>
      <MoveSelector />
      <PersonalPromptBuilder />
      <PersonalNotes />
    </SectionShell>
  );
};

export default PersonalSection;
'@
Write-Source -Path 'src/sections/07-personal/MoveSelector.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// MoveSelector — 3 buttons, one per move. Teacher picks which move
// fits their class topic. Selection persists to ModuleProgress.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbCheck } from 'react-icons/tb';
import { MOVES } from '@/data/threeMoves';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import type { MoveKey } from '@/types/module.types';
import styles from './MoveSelector.module.scss';

const MoveSelector: React.FC = () => {
  const { progress, setPersonalMove } = useProgressCtx();
  const selected = progress.personalMove;

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.tag}>הבחירה שלכם</span>
        <h3 className={styles.title}>איזה מהלך מתאים לשיעור שאתם בונים?</h3>
        <p className={styles.lede}>
          תזכרו — כל מהלך מצוין בגיל מסוים, אבל אפשר להשתמש בכל אחד בכל גיל. בחרו לפי
          <strong> סוג הנושא</strong>, לא לפי שכבת הגיל.
        </p>
      </header>

      <ul className={styles.options}>
        {MOVES.map(m => {
          const active = selected === m.id;
          return (
            <li key={m.id}>
              <button
                type="button"
                onClick={() => setPersonalMove(m.id as MoveKey)}
                className={[
                  styles.option,
                  styles[`tint-${m.tint}`],
                  active && styles.optionActive,
                ].filter(Boolean).join(' ')}
                aria-pressed={active}
              >
                <header className={styles.optionHead}>
                  <span className={styles.optionNum}>מהלך {m.number}</span>
                  {active && (
                    <span className={styles.optionCheck} aria-label="נבחר">
                      <TbCheck aria-hidden />
                    </span>
                  )}
                </header>
                <h4 className={styles.optionName}>{m.nameHe}</h4>
                <p className={styles.optionPower}>{m.superpower}</p>
                <span className={styles.optionTransform}>
                  {m.transform.from} <span aria-hidden>←</span> <strong>{m.transform.to}</strong>
                </span>
              </button>
            </li>
          );
        })}
      </ul>
    </section>
  );
};

export default MoveSelector;
'@
Write-Source -Path 'src/sections/07-personal/MoveSelector.module.scss' -Body @'
.section { @include flex-col; gap: $space-4; }

.head { @include flex-col; gap: $space-1; }

.tag {
  font-family: $font-script;
  font-size: 22px;
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
  margin: 0;
  line-height: 1.15;
}

.lede {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue-soft;
  max-width: 640px;

  strong { color: $red-pen; font-weight: $weight-bold; }
}

.options {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: $space-3;
  grid-template-columns: 1fr;

  @include respond-to(md) { grid-template-columns: repeat(3, 1fr); }
}

.option {
  @include paper-card;
  @include focus-ring;
  width: 100%;
  text-align: start;
  cursor: pointer;
  padding: $space-4 $space-4;
  background: $paper-cream;
  border: 2px solid $paper-line;
  transition: all $dur-fast $ease-out;
  @include flex-col;
  gap: $space-2;

  &:hover {
    transform: translateY(-2px);
    box-shadow: $shadow-lift;
  }
}

.tint-yellow:hover { border-color: $highlight-dark; }
.tint-blue:hover   { border-color: $tape-washi-dark; }
.tint-red:hover    { border-color: $red-pen; }

.optionActive {
  background: $paper-cream-2;

  &.tint-yellow { border-color: $highlight-dark !important; box-shadow: 0 0 0 3px rgba($highlight, 0.18); }
  &.tint-blue   { border-color: $tape-washi-dark !important; box-shadow: 0 0 0 3px rgba($tape-washi, 0.35); }
  &.tint-red    { border-color: $red-pen !important;        box-shadow: 0 0 0 3px rgba($red-pen, 0.16); }
}

.optionHead {
  @include flex-between;
  align-items: center;
}

.optionNum {
  font-family: $font-mono;
  font-size: 10px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: $red-pen;
  font-weight: $weight-bold;
}

.optionCheck {
  @include flex-center;
  width: 24px; height: 24px;
  border-radius: 50%;
  background: $success;
  color: $white;
  font-size: 14px;
}

.optionName {
  margin: 0;
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
}

.optionPower {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-body;
  color: $ink-blue;
  font-weight: $weight-medium;
}

.optionTransform {
  font-family: $font-mono;
  font-size: $text-xs;
  color: $ink-blue-soft;
  margin-top: $space-1;

  strong { color: $red-pen; font-weight: $weight-bold; }
}
'@
Write-Source -Path 'src/sections/07-personal/PersonalPromptBuilder.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// PersonalPromptBuilder — once the teacher has picked a move AND
// filled their class (in Break section), we generate a personalized
// 4-part prompt and show it with a copy button.
// ═══════════════════════════════════════════════════════════════════
import React, { useMemo } from 'react';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import { MOVE_BY_ID } from '@/data/threeMoves';
import PromptDemo, { type FourPartPrompt } from '@/components/PromptDemo/PromptDemo';
import type { CustomTopic, MoveKey } from '@/types/module.types';
import styles from './PersonalPromptBuilder.module.scss';

// Templates per move — fill with the teacher's class data
function buildPrompt(move: MoveKey, topic: CustomTopic): FourPartPrompt {
  const ctxLine = `אני מחנכ/ת של ${topic.grade}. הנושא: ${topic.topic}.${topic.context ? ' ' + topic.context : ''}`;

  if (move === 'scenarios') {
    return {
      role: 'מומחה/ית להוראת חינוך. את/ה מתמחה בבניית סיפורים קצרים שעוזרים לתלמידים לדבר על הנושא בלי הטפה.',
      context: ctxLine,
      task: 'צור/י 3 סיפורים קצרים על תלמידים בני גיל זה שעוברים את הסיטואציה הזאת, כל אחד מסיבה שונה. שמות, פרטים, רגעים ספציפיים.',
      format: 'לכל סיפור עד 120 מילים + 4 שאלות לדיון. בסוף — פעילות סיכום אחת ל-15 דק׳ שמחברת את כל הסיפורים.',
    };
  }

  if (move === 'voices') {
    return {
      role: 'מומחה/ית להוראת חינוך. את/ה מתמחה בהצגת דילמות מ-3 פרספקטיבות, בלי "צד נכון".',
      context: ctxLine,
      task: 'תאר/י את אותו אירוע / דילמה מ-3 פרספקטיבות: (1) המורה מבחוץ, (2) תלמיד/ה שהשתתף/ה / ראה/תה, (3) הורה שמגלה אחר כך. כל קול בגוף ראשון, באוצר מילים מציאותי לגיל.',
      format: 'אחרי שלושת הקולות — פרוטוקול דיון "4 פינות": 4 עמדות אפשריות שתלמידים יכולים לזהות איתן, עם שאלה לכל עמדה.',
    };
  }

  return {
    role: 'מומחה/ית להוראת חינוך. את/ה מתמחה בדיונים ערכיים בלי לדחוף מסקנה אחת.',
    context: ctxLine,
    task: 'תאר/י 4-5 מקרים אמיתיים של בני אדם שהתמודדו עם הדילמה הזאת (כל אחד בחר אחרת). חלץ/י מהם את 3-4 הערכים המרכזיים שעמדו מאחורי הבחירות.',
    format: 'כרטיסיות מקרה (כל אחת ~100 מילים) + רשימת ערכים לפעילות מיון (10-12 ערכים) + 3 שאלות סיכום שמובילות לפעולה אישית.',
  };
}

const PersonalPromptBuilder: React.FC = () => {
  const { progress } = useProgressCtx();
  const move = progress.personalMove;
  const topic = progress.customTopic;

  const prompt = useMemo<FourPartPrompt | null>(() => {
    if (!move || !topic) return null;
    return buildPrompt(move, topic);
  }, [move, topic]);

  if (!move) {
    return (
      <aside className={styles.empty}>
        <p>בחרו מהלך למעלה כדי לראות את הפרומפט המותאם לכיתה שלכם.</p>
      </aside>
    );
  }

  if (!topic) {
    return (
      <aside className={styles.empty}>
        <p>נראה שלא מילאתם את פרטי הכיתה בחלק 4 (הפסקה). חזרו לשם, מלאו, וחזרו לכאן.</p>
      </aside>
    );
  }

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.tag}>הפרומפט שלכם</span>
        <h3 className={styles.title}>
          מותאם ל-<strong>{topic.grade}</strong> · {topic.topic}
        </h3>
        <p className={styles.lede}>
          מבוסס על <strong>{MOVE_BY_ID[move].nameHe}</strong>. העתיקו את הפרומפט המלא,
          הריצו אותו ב-AI, וקבלו פלט שאתם יכולים לקחת ישר לכיתה מחר.
        </p>
      </header>

      <PromptDemo prompt={prompt!} />
    </section>
  );
};

export default PersonalPromptBuilder;
'@
Write-Source -Path 'src/sections/07-personal/PersonalPromptBuilder.module.scss' -Body @'
.section { @include flex-col; gap: $space-4; }

.head { @include flex-col; gap: $space-1; }

.tag {
  font-family: $font-script;
  font-size: 22px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.title {
  font-family: $font-display;
  font-size: $text-lg;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin: 0;

  strong { color: $red-pen; }

  @include respond-to(md) { font-size: $text-xl; }
}

.lede {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue-soft;
  max-width: 640px;

  strong { color: $ink-blue-dark; font-weight: $weight-bold; }
}

.empty {
  padding: $space-5;
  background: $paper-cream;
  border: 1.5px dashed $pencil-light;
  border-radius: $radius-md;
  color: $ink-blue-soft;
  font-size: $text-sm;
  text-align: center;

  p { margin: 0; line-height: $leading-loose; }
}
'@
Write-Source -Path 'src/sections/07-personal/PersonalNotes.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// PersonalNotes — after running the prompt in AI, the teacher pastes
// the output here. Stored in localStorage; used by Section 8 for the
// personal lesson PDF.
// ═══════════════════════════════════════════════════════════════════
import React, { useEffect, useState } from 'react';
import { TbNotebook } from 'react-icons/tb';
import styles from './PersonalNotes.module.scss';

const STORAGE_KEY = 'binai.m04.personalNotes.v1';

function load(): string {
  try { return localStorage.getItem(STORAGE_KEY) ?? ''; } catch { return ''; }
}

const PersonalNotes: React.FC = () => {
  const [notes, setNotes] = useState(load);

  useEffect(() => {
    try { localStorage.setItem(STORAGE_KEY, notes); } catch { /* private mode */ }
  }, [notes]);

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.icon} aria-hidden><TbNotebook /></span>
        <div>
          <span className={styles.tag}>הפלט שלכם</span>
          <h3 className={styles.title}>הדביקו כאן את התשובה של ה-AI</h3>
          <p className={styles.lede}>
            הריצו את הפרומפט למעלה ב-ChatGPT / Claude / Gemini. העתיקו את התשובה ושמרו כאן —
            בחלק 8 (סיכום) זה ייכנס ל-PDF של השיעור שלכם.
          </p>
        </div>
      </header>

      <textarea
        className={styles.textarea}
        value={notes}
        onChange={e => setNotes(e.target.value)}
        rows={10}
        placeholder='הפלט מ-AI יודבק כאן. נשמר אוטומטית.'
      />
    </section>
  );
};

export default PersonalNotes;
'@
Write-Source -Path 'src/sections/07-personal/PersonalNotes.module.scss' -Body @'
.section { @include flex-col; gap: $space-3; }

.head {
  @include flex-start;
  gap: $space-3;
  align-items: flex-start;

  > div { flex: 1; @include flex-col; gap: 2px; }
}

.icon {
  @include flex-center;
  width: 44px; height: 44px;
  border-radius: 50%;
  background: $tape-washi;
  color: $ink-blue-dark;
  font-size: 22px;
  flex-shrink: 0;
}

.tag {
  font-family: $font-script;
  font-size: 18px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.title {
  margin: 0;
  font-family: $font-display;
  font-size: $text-md;
  font-weight: $weight-bold;
  color: $ink-blue-dark;

  @include respond-to(md) { font-size: $text-lg; }
}

.lede {
  margin: 0;
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue-soft;
}

.textarea {
  width: 100%;
  font-family: $font-body;
  font-size: $text-base;
  line-height: $leading-body;
  color: $ink-blue-dark;
  background: $paper-cream;
  border: 1.5px solid $paper-line;
  border-radius: $radius-md;
  padding: $space-3 $space-4;
  resize: vertical;
  min-height: 200px;
  transition: all $dur-fast $ease-out;

  &::placeholder { color: $pencil-light; }
  &:focus {
    outline: none;
    border-color: $red-pen;
    box-shadow: 0 0 0 3px rgba($red-pen, 0.12);
  }
}
'@
Write-Source -Path 'src/sections/08-closing/index.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// Section 08 — סיכום (25 min)
// Three parts: celebratory hero · 4 lesson PDFs · final commitment.
// On "סיימתי את ההשתלמות" → marks module complete.
// ═══════════════════════════════════════════════════════════════════
import React, { useEffect, useState } from 'react';
import { TbCheck, TbAward } from 'react-icons/tb';
import SectionShell from '@/components/SectionShell/SectionShell';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import ClosingHero from './ClosingHero';
import LessonPDFSet from './LessonPDFSet';
import styles from './index.module.scss';

const COMMIT_KEY = 'binai.m04.commit.v1';
const loadCommit = (): string => {
  try { return localStorage.getItem(COMMIT_KEY) ?? ''; } catch { return ''; }
};

const ClosingSection: React.FC = () => {
  const { progress, complete } = useProgressCtx();
  const [commitment, setCommitment] = useState(loadCommit);
  const isComplete = progress.sections.closing?.completed === true;

  useEffect(() => {
    try { localStorage.setItem(COMMIT_KEY, commitment); } catch { /* private */ }
  }, [commitment]);

  return (
    <SectionShell id="closing">
      <ClosingHero />
      <LessonPDFSet />

      {/* COMMITMENT */}
      <section className={styles.takeaway}>
        <header className={styles.takeawayHead}>
          <span className={styles.tag}>המחויבות שלי</span>
          <h3 className={styles.takeawayTitle}>השיעור הראשון שאני באמת אעביר</h3>
          <p className={styles.takeawayLede}>
            מתוך 4 השיעורים — איזה אחד תעבירו <strong>השבוע הקרוב</strong>?
            כתבו שורה אחת לעצמכם.
          </p>
        </header>

        <textarea
          className={styles.commitInput}
          value={commitment}
          onChange={e => setCommitment(e.target.value)}
          placeholder='ביום ___ אעביר את "___" בכיתה ___.'
          rows={2}
        />

        <div className={styles.finishRow}>
          {isComplete ? (
            <span className={styles.finishDone}>
              <TbAward aria-hidden />
              <span>השתלמות הושלמה · כל הכבוד!</span>
            </span>
          ) : (
            <button type="button" className={styles.finishBtn} onClick={() => complete('closing')}>
              <TbCheck aria-hidden />
              <span>סיימתי את ההשתלמות</span>
            </button>
          )}
        </div>
      </section>
    </SectionShell>
  );
};

export default ClosingSection;
'@
Write-Source -Path 'src/sections/08-closing/index.module.scss' -Body @'
.takeaway {
  @include paper-card;
  padding: $space-5 $space-6;
  border-inline-start: 4px solid $highlight-dark;
  @include flex-col;
  gap: $space-4;
}

.takeawayHead { @include flex-col; gap: $space-2; }

.tag {
  font-family: $font-script;
  font-size: 22px;
  color: $red-pen;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.takeawayTitle {
  font-family: $font-display;
  font-size: $text-xl;
  font-weight: $weight-bold;
  color: $ink-blue-dark;
  margin: 0;
}

.takeawayLede {
  margin: 0;
  font-size: $text-md;
  line-height: $leading-loose;
  color: $ink-blue-soft;

  strong { color: $red-pen; font-weight: $weight-bold; }
}

.commitInput {
  width: 100%;
  font-family: $font-script;
  font-size: $text-lg;
  line-height: $leading-body;
  color: $ink-blue-dark;
  background: $highlight-pale;
  border: 1.5px solid $paper-line;
  border-radius: $radius-md;
  padding: $space-3 $space-4;
  resize: vertical;
  min-height: 64px;
  transition: all $dur-fast $ease-out;

  &::placeholder { color: $ink-blue-soft; font-style: italic; }
  &:focus {
    outline: none;
    border-color: $highlight-dark;
    box-shadow: 0 0 0 3px rgba($highlight, 0.3);
  }
}

.finishRow {
  display: flex;
  justify-content: center;
  margin-top: $space-2;
}

.finishBtn {
  @include focus-ring;
  @include flex-center;
  gap: $space-2;
  padding: $space-3 $space-7;
  background: $ink-blue-dark;
  color: $paper-cream;
  border: 1.5px solid $ink-blue-dark;
  border-radius: $radius-full;
  font-family: $font-body;
  font-size: $text-md;
  font-weight: $weight-bold;
  cursor: pointer;
  transition: all $dur-fast $ease-out;

  svg { font-size: 20px; }

  &:hover {
    background: $ink-blue;
    transform: translateY(-1px);
    box-shadow: $shadow-lift;
  }
}

.finishDone {
  @include flex-center;
  gap: $space-2;
  padding: $space-3 $space-6;
  background: $success-pale;
  border: 1.5px solid $success;
  border-radius: $radius-full;
  color: $success;
  font-family: $font-display;
  font-weight: $weight-bold;
  font-size: $text-md;

  svg { font-size: 22px; }
}

@media print {
  .takeaway { display: none !important; }
}
'@
Write-Source -Path 'src/sections/08-closing/ClosingHero.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// ClosingHero — celebratory banner.
// Shows: 8/8 sections complete + the teacher's class + which move they
// picked for the personal lesson.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbConfetti } from 'react-icons/tb';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import { MOVE_BY_ID } from '@/data/threeMoves';
import styles from './ClosingHero.module.scss';

const ClosingHero: React.FC = () => {
  const { progress } = useProgressCtx();
  const move = progress.personalMove ? MOVE_BY_ID[progress.personalMove] : null;
  const topic = progress.customTopic;

  return (
    <section className={styles.hero}>
      <div className={styles.icon} aria-hidden><TbConfetti /></div>
      <div className={styles.body}>
        <span className={styles.eyebrow}>סיימתם · 8/8</span>
        <h2 className={styles.title}>4 שיעורים. מוכנים לכיתה.</h2>
        <p className={styles.lede}>
          3 שיעורי דמו (יסודי · חט״ב · תיכון) שבנינו יחד, ועוד שיעור אישי שאתם
          בניתם לכיתה האמיתית שלכם. <strong>הכל כאן למטה — מוכן ל-PDF.</strong>
        </p>

        <dl className={styles.stats}>
          <div className={styles.stat}>
            <dt>חלקים</dt>
            <dd>8<span> / 8</span></dd>
          </div>
          {topic && (
            <div className={`${styles.stat} ${styles.statWide}`}>
              <dt>הכיתה שלכם</dt>
              <dd className={styles.statText}>{topic.grade} · {topic.topic}</dd>
            </div>
          )}
          {move && (
            <div className={styles.stat}>
              <dt>המהלך שבחרתם</dt>
              <dd className={styles.statText}>{move.nameHe}</dd>
            </div>
          )}
        </dl>
      </div>
    </section>
  );
};

export default ClosingHero;
'@
Write-Source -Path 'src/sections/08-closing/ClosingHero.module.scss' -Body @'
.hero {
  background: $ink-blue-dark;
  color: $paper-cream;
  border-radius: $radius-lg;
  padding: $space-6;
  display: grid;
  grid-template-columns: auto 1fr;
  gap: $space-5;
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image:
      radial-gradient(circle at 30% 30%, rgba(244,213,90,0.08) 1px, transparent 2px),
      radial-gradient(circle at 70% 60%, rgba(168,200,218,0.08) 1px, transparent 2px);
    background-size: 32px 32px, 40px 40px;
    pointer-events: none;
  }

  > * { position: relative; z-index: 1; }

  @media (max-width: $bp-md) { grid-template-columns: 1fr; }
}

.icon {
  @include flex-center;
  width: 72px; height: 72px;
  border-radius: 50%;
  background: $highlight;
  color: $ink-blue-dark;
  font-size: 36px;
  flex-shrink: 0;
}

.body { @include flex-col; gap: $space-2; }

.eyebrow {
  font-family: $font-script;
  font-size: 20px;
  color: $highlight;
  font-weight: $weight-bold;
  transform: rotate(-1deg);
  display: inline-block;
}

.title {
  margin: 0;
  font-family: $font-display;
  font-weight: $weight-bold;
  font-size: $text-2xl;
  color: $paper-cream;
  line-height: 1.1;
  letter-spacing: -0.01em;

  @include respond-to(md) { font-size: $text-3xl; }
}

.lede {
  margin: 0;
  font-size: $text-md;
  line-height: $leading-loose;
  color: rgba(250, 246, 232, 0.85);
  max-width: 580px;

  strong { color: $highlight; font-weight: $weight-bold; }
}

.stats {
  margin: $space-3 0 0;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: $space-3;
}

.stat {
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: $radius-md;
  padding: $space-3 $space-4;
  @include flex-col;
  gap: 2px;

  dt {
    font-family: $font-mono;
    font-size: 10px;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: $highlight;
  }

  dd {
    margin: 0;
    font-family: $font-display;
    font-size: $text-xl;
    font-weight: $weight-bold;
    color: $paper-cream;

    span {
      font-size: $text-base;
      color: rgba(250, 246, 232, 0.6);
      font-weight: $weight-medium;
    }
  }
}

.statWide { grid-column: 1 / -1; }

.statText {
  font-size: $text-md !important;
  word-break: break-word;
}
'@
Write-Source -Path 'src/sections/08-closing/LessonPDFSet.tsx' -Body @'
// ═══════════════════════════════════════════════════════════════════
// LessonPDFSet — 4 lesson cards (3 demo + 1 personal).
// Each card has a "print this lesson" button that triggers print
// after setting the document body to that specific lesson's content.
// Implementation: each PDF card has className `m04-print` but only
// the active one gets `m04-print-active` (which the print CSS uses).
// ═══════════════════════════════════════════════════════════════════
import React, { useState } from 'react';
import { TbPrinter, TbFileText } from 'react-icons/tb';
import { MOVES } from '@/data/threeMoves';
import { SCENARIO_DEMO, VOICES_DEMO, CASE_DEMO } from '@/data/moveDemos';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import styles from './LessonPDFSet.module.scss';

interface PDFLesson {
  id: string;
  moveId: 'scenarios' | 'voices' | 'case' | 'personal';
  tier: string;
  title: string;
  topic: string;
  grade: string;
  totalMin: number;
  blocks: { time: string; name: string; body: string }[];
  /** For personal: paste of AI output */
  notes?: string;
}

const LessonPDFSet: React.FC = () => {
  const { progress } = useProgressCtx();
  const [activeId, setActiveId] = useState<string | null>(null);

  // Load personal notes
  let personalNotes = '';
  try { personalNotes = localStorage.getItem('binai.m04.personalNotes.v1') ?? ''; } catch { /* noop */ }

  const moveScenarios = MOVES.find(m => m.id === 'scenarios')!;
  const moveVoices = MOVES.find(m => m.id === 'voices')!;
  const moveCase = MOVES.find(m => m.id === 'case')!;
  const personalMove = progress.personalMove ? MOVES.find(m => m.id === progress.personalMove) : null;

  const lessons: PDFLesson[] = [
    {
      id: 'pdf-scenarios',
      moveId: 'scenarios',
      tier: `יסודי · ${moveScenarios.nameHe}`,
      title: SCENARIO_DEMO.topic,
      topic: SCENARIO_DEMO.topic,
      grade: SCENARIO_DEMO.grade,
      totalMin: SCENARIO_DEMO.plan.totalMin,
      blocks: SCENARIO_DEMO.plan.blocks,
    },
    {
      id: 'pdf-voices',
      moveId: 'voices',
      tier: `חט״ב · ${moveVoices.nameHe}`,
      title: VOICES_DEMO.topic,
      topic: VOICES_DEMO.topic,
      grade: VOICES_DEMO.grade,
      totalMin: VOICES_DEMO.plan.totalMin,
      blocks: VOICES_DEMO.plan.blocks,
    },
    {
      id: 'pdf-case',
      moveId: 'case',
      tier: `תיכון · ${moveCase.nameHe}`,
      title: CASE_DEMO.topic,
      topic: CASE_DEMO.topic,
      grade: CASE_DEMO.grade,
      totalMin: CASE_DEMO.plan.totalMin,
      blocks: CASE_DEMO.plan.blocks,
    },
  ];

  // Personal lesson — only added if both class topic + move + notes are set
  if (progress.customTopic && personalMove) {
    lessons.push({
      id: 'pdf-personal',
      moveId: 'personal',
      tier: `הכיתה שלכם · ${personalMove.nameHe}`,
      title: progress.customTopic.topic,
      topic: progress.customTopic.topic,
      grade: progress.customTopic.grade,
      totalMin: 45,
      blocks: [], // populated by the AI output below
      notes: personalNotes,
    });
  }

  const handlePrint = (id: string) => {
    setActiveId(id);
    // tiny delay so React re-renders before print()
    setTimeout(() => { window.print(); setTimeout(() => setActiveId(null), 200); }, 50);
  };

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.tag}>4 שיעורים · PDF</span>
        <h3 className={styles.title}>קחו לכיתה</h3>
        <p className={styles.lede}>
          לכל שיעור — כפתור הדפסה. הדפדפן יפתח חלון "הדפסה / שמירה כ-PDF". בחרו "שמירה כ-PDF" כיעד.
        </p>
      </header>

      <ul className={styles.cards}>
        {lessons.map(l => (
          <li
            key={l.id}
            className={[
              styles.card,
              activeId === l.id && 'm04-print',
            ].filter(Boolean).join(' ')}
          >
            {/* Card head (visible on screen) */}
            <header className={styles.cardHead}>
              <span className={styles.cardIcon} aria-hidden><TbFileText /></span>
              <div>
                <span className={styles.cardTier}>{l.tier}</span>
                <h4 className={styles.cardTitle}>{l.title}</h4>
                <span className={styles.cardMeta}>{l.grade} · {l.totalMin} דק׳</span>
              </div>
              <button
                type="button"
                onClick={() => handlePrint(l.id)}
                className={styles.printBtn}
                aria-label={`שמור כ-PDF: ${l.title}`}
              >
                <TbPrinter aria-hidden />
                <span>שמור כ-PDF</span>
              </button>
            </header>

            {/* Print content (formatted for PDF) */}
            <div className={`${styles.printBody} m04-print-field`}>
              <h2>{l.title}</h2>
              <p className={styles.printMeta}>{l.tier} · {l.grade} · {l.totalMin} דק׳</p>

              {l.blocks.length > 0 && (
                <table className={styles.printTable}>
                  <thead>
                    <tr><th>זמן</th><th>שלב</th><th>תוכן</th></tr>
                  </thead>
                  <tbody>
                    {l.blocks.map((b, i) => (
                      <tr key={i}>
                        <td>{b.time}</td>
                        <td><strong>{b.name}</strong></td>
                        <td>{b.body}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}

              {l.notes && (
                <>
                  <h3>הפלט מ-AI</h3>
                  <pre className={styles.printNotes}>{l.notes}</pre>
                </>
              )}
            </div>
          </li>
        ))}
      </ul>
    </section>
  );
};

export default LessonPDFSet;
'@
Write-Source -Path 'src/sections/08-closing/LessonPDFSet.module.scss' -Body @'
.section { @include flex-col; gap: $space-4; }

.head { @include flex-col; gap: $space-1; }

.tag {
  font-family: $font-script;
  font-size: 22px;
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
  margin: 0;
}

.lede {
  font-size: $text-sm;
  line-height: $leading-loose;
  color: $ink-blue-soft;
  margin: 0;
  max-width: 640px;
}

// ── CARDS ──────────────────────────────────────────────────────
.cards {
  list-style: none;
  margin: 0;
  padding: 0;
  @include flex-col;
  gap: $space-3;
}

.card {
  @include paper-card;
  padding: 0;
}

.cardHead {
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: $space-3;
  padding: $space-4 $space-5;

  > div { @include flex-col; gap: 2px; }
}

.cardIcon {
  @include flex-center;
  width: 48px; height: 48px;
  border-radius: $radius-md;
  background: $highlight-pale;
  color: $highlight-dark;
  font-size: 24px;
}

.cardTier {
  font-family: $font-mono;
  font-size: 10px;
  letter-spacing: 0.14em;
  color: $red-pen;
  text-transform: uppercase;
  font-weight: $weight-bold;
}

.cardTitle {
  margin: 0;
  font-family: $font-display;
  font-size: $text-md;
  font-weight: $weight-bold;
  color: $ink-blue-dark;

  @include respond-to(md) { font-size: $text-lg; }
}

.cardMeta {
  font-family: $font-mono;
  font-size: $text-xs;
  color: $ink-blue-soft;
}

// ── PRINT BUTTON ───────────────────────────────────────────────
.printBtn {
  @include focus-ring;
  @include flex-start;
  gap: $space-2;
  padding: $space-2 $space-4;
  background: $red-pen;
  color: $paper-cream;
  border: 1.5px solid $red-pen;
  border-radius: $radius-full;
  font-family: $font-body;
  font-size: $text-sm;
  font-weight: $weight-bold;
  cursor: pointer;
  transition: all $dur-fast $ease-out;

  svg { font-size: 16px; }

  &:hover {
    background: $red-pen-dark;
    border-color: $red-pen-dark;
    transform: translateY(-1px);
  }
}

// ── PRINT BODY (hidden on screen, visible in print) ────────────
.printBody {
  display: none;
}

.printMeta {
  font-family: $font-mono;
  font-size: 12pt;
  color: #555;
  margin: 0 0 12pt;
}

.printTable {
  width: 100%;
  border-collapse: collapse;
  margin: 12pt 0;

  th, td {
    border: 1px solid #999;
    padding: 6pt 10pt;
    text-align: start;
    font-size: 11pt;
    vertical-align: top;
  }

  th {
    background: #eee;
    font-weight: bold;
    font-family: serif;
  }

  td:first-child {
    font-family: monospace;
    white-space: nowrap;
  }
}

.printNotes {
  font-family: 'Assistant', sans-serif;
  font-size: 11pt;
  line-height: 1.6;
  white-space: pre-wrap;
  margin: 8pt 0;
  padding: 8pt;
  border-inline-start: 2px solid #999;
}

// ═══════════════════════════════════════════════════════════════
// PRINT: show only the active card's content, hide UI affordances
// ═══════════════════════════════════════════════════════════════
@media print {
  .cards, .head, .cardHead, .card { box-shadow: none !important; background: none !important; }
  .printBtn, .cardIcon { display: none !important; }
  .cardHead > div { display: none; }
  .printBody { display: block; }

  h2 {
    font-size: 18pt !important;
    font-family: 'Suez One', serif;
    margin-bottom: 6pt;
  }

  h3 {
    font-size: 14pt;
    margin-top: 16pt;
    margin-bottom: 6pt;
  }
}
'@

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  Done. Run: npm run dev" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
