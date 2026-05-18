// ═══════════════════════════════════════════════════════════════════
// LessonPDFSet — 4 lesson cards (3 demo + 1 personal if filled).
// Each card has a "save as PDF" button.
//
// PRINT ISOLATION: when a card is active, its printable content is
// rendered via React.createPortal directly into <body>, inside a
// `.m04-print-host` wrapper. The global print CSS hides #root and
// shows only the portal — so the print output starts cleanly on
// page 1 with no blank pages from invisible-but-still-laid-out content.
// ═══════════════════════════════════════════════════════════════════
import React, { useState } from 'react';
import { createPortal } from 'react-dom';
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

// ─── Printable view (rendered in the portal during print) ──────
const PrintableLesson: React.FC<{ lesson: PDFLesson }> = ({ lesson: l }) => (
  <article className={styles.printPage} dir="rtl">
    <header className={styles.printHeader}>
      <span className={styles.printEyebrow}>{l.tier}</span>
      <h1 className={styles.printH1}>{l.title}</h1>
      <p className={styles.printMeta}>{l.grade} · {l.totalMin} דקות</p>
    </header>

    {l.blocks.length > 0 && (
      <section className="m04-print-field">
        <h2 className={styles.printH2}>מערך השיעור</h2>
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
      </section>
    )}

    {l.notes && (
      <section className="m04-print-field">
        <h2 className={styles.printH2}>הפלט מ-AI</h2>
        <pre className={styles.printNotes}>{l.notes}</pre>
      </section>
    )}

    <footer className={styles.printFooter}>
      <span>BinAI · 3 מהלכים בשיעור חינוך · {new Date().toLocaleDateString('he-IL')}</span>
    </footer>
  </article>
);

// ─── Main component ────────────────────────────────────────────
const LessonPDFSet: React.FC = () => {
  const { progress } = useProgressCtx();
  const [activeId, setActiveId] = useState<string | null>(null);

  let personalNotes = '';
  try { personalNotes = localStorage.getItem('binai.m04.personalNotes.v1') ?? ''; } catch { /* noop */ }

  const moveScenarios = MOVES.find(m => m.id === 'scenarios')!;
  const moveVoices    = MOVES.find(m => m.id === 'voices')!;
  const moveCase      = MOVES.find(m => m.id === 'case')!;
  const personalMove  = progress.personalMove ? MOVES.find(m => m.id === progress.personalMove) : null;

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

  if (progress.customTopic && personalMove) {
    lessons.push({
      id: 'pdf-personal',
      moveId: 'personal',
      tier: `הכיתה שלכם · ${personalMove.nameHe}`,
      title: progress.customTopic.topic,
      topic: progress.customTopic.topic,
      grade: progress.customTopic.grade,
      totalMin: 45,
      blocks: [],
      notes: personalNotes,
    });
  }

  const handlePrint = (id: string) => {
    setActiveId(id);
    // Give React time to mount the portal before invoking print()
    setTimeout(() => {
      window.print();
      // Give the print dialog time to open & capture before unmounting
      setTimeout(() => setActiveId(null), 400);
    }, 80);
  };

  const activeLesson = activeId
    ? lessons.find(l => l.id === activeId) ?? null
    : null;

  return (
    <>
      {/* ── ON-SCREEN: 4 cards with print buttons ───────────────── */}
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
            <li key={l.id} className={styles.card}>
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
            </li>
          ))}
        </ul>
      </section>

      {/* ── PRINT PORTAL: rendered to <body>, only visible in print ── */}
      {activeLesson && createPortal(
        <div className="m04-print-host" dir="rtl">
          <PrintableLesson lesson={activeLesson} />
        </div>,
        document.body,
      )}
    </>
  );
};

export default LessonPDFSet;