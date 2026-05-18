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