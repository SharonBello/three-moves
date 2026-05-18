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