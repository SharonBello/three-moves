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