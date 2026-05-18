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