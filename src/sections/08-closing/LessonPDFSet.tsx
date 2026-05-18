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