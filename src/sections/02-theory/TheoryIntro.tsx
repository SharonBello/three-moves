// ═══════════════════════════════════════════════════════════════════
// TheoryIntro — the framing card before the workbench.
// Explains the "moves" metaphor and the age-tier pairing logic.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import styles from './TheoryIntro.module.scss';

const TheoryIntro: React.FC = () => (
  <section className={styles.intro}>
    <span className={styles.tag}>מדריך מהיר</span>
    <h2 className={styles.title}>
      שלושה מהלכים. <span className={styles.hl}>שלוש דרכים</span> להפעיל AI.
    </h2>
    <p className={styles.lede}>
      כל מהלך הוא <strong>תבנית שימוש</strong> ב-AI לתכנון שיעור חינוך — לא ברירת מחדל. כל אחד
      מצטיין בגיל מסוים, אבל אפשר להשתמש בכולם בכל גיל. בחלקים הבאים נראה כל מהלך בפעולה ונפיק
      שיעור מוכן.
    </p>
  </section>
);

export default TheoryIntro;