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