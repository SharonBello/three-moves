// ═══════════════════════════════════════════════════════════════════
// Section 04 — הפסקה · בחירת הכיתה (15 min)
// Two purposes:
//   (1) Mid-workshop pause (water, stretch).
//   (2) Teacher fills in their REAL class for the personal lesson
//       (used in Section 7).
// Next button is gated on the class-picker being valid.
// ═══════════════════════════════════════════════════════════════════
import React, { useState } from 'react';
import { TbCoffee } from 'react-icons/tb';
import SectionShell from '@/components/SectionShell/SectionShell';
import ClassPicker from './ClassPicker';
import styles from './index.module.scss';

const BreakSection: React.FC = () => {
  const [valid, setValid] = useState(false);

  return (
    <SectionShell id="break" canAdvance={valid}>
      <aside className={styles.banner}>
        <span className={styles.icon} aria-hidden><TbCoffee /></span>
        <div>
          <h2 className={styles.title}>הפסקה של 10 דקות</h2>
          <p className={styles.lede}>
            קחו אוויר, מים, מתיחה. וכשתחזרו — תמלאו את הטופס למטה.
            השיעור האחרון (חלק 7) ייבנה על הכיתה האמיתית שלכם.
          </p>
        </div>
      </aside>

      <ClassPicker onValidityChange={setValid} />
    </SectionShell>
  );
};

export default BreakSection;