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