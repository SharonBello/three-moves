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