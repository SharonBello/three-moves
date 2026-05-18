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