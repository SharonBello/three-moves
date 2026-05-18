// ═══════════════════════════════════════════════════════════════════
// PrepProblem — the "why this module exists" narrative.
// Three sticky-note quotes from real teacher pain points,
// then a synthesis paragraph.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import styles from './PrepProblem.module.scss';

interface Pain {
  quote: string;
  role: string;
  rotation: number;
  bg: 'yellow' | 'cream' | 'kraft';
}

const PAINS: Pain[] = [
  {
    quote: 'יום ראשון, 8:00. כיתה ז\'1 כבר במסדרון. ואני... עדיין לא יודעת על מה אדבר היום.',
    role: 'מחנכת חט״ב',
    rotation: -2,
    bg: 'yellow',
  },
  {
    quote: 'ב-13:00 הייתה תקרית בכיתה. ב-13:30 אני צריך לדבר עליה — בלי לעשות נזק.',
    role: 'מחנך יסודי',
    rotation: 1.5,
    bg: 'cream',
  },
  {
    quote: 'המנהל ביקש שיעור על אנטישמיות. אני... אפילו לא יודעת איך להתחיל.',
    role: 'מחנכת תיכון',
    rotation: -1,
    bg: 'kraft',
  },
];

const PrepProblem: React.FC = () => (
  <section className={styles.section}>
    <header className={styles.intro}>
      <span className={styles.tag}>הבעיה</span>
      <h2 className={styles.title}>
        שיעור חינוך הוא <em>השיעור הכי קשה להכין.</em>
      </h2>
      <p className={styles.lede}>
        אין ספר. אין סילבוס. אין תשובה נכונה אחת. רק אתם, התלמידים, ו-45 דקות
        שצריכות להיות <span className={styles.hl}>משמעותיות</span>.
      </p>
    </header>

    <ul className={styles.pains} aria-label="דוגמאות לקושי בהכנת שיעור חינוך">
      {PAINS.map((p, i) => (
        <li
          key={i}
          className={`${styles.pain} ${styles[`pain-${p.bg}`]}`}
          style={{ '--rot': `${p.rotation}deg` } as React.CSSProperties}
        >
          <blockquote className={styles.quote}>“{p.quote}”</blockquote>
          <cite className={styles.role}>— {p.role}</cite>
        </li>
      ))}
    </ul>

    <aside className={styles.bridge}>
      <span className={styles.bridgeBadge}>מה נלמד</span>
      <p>
        המודול הזה לוקח את 90 הדקות של הכנה (כשיש לכם זמן) ל-15 דקות (כשאין).
        <strong> 3 מהלכים. 3 שיעורים מוכנים. שיעור אחד משלכם.</strong>
      </p>
    </aside>
  </section>
);

export default PrepProblem;