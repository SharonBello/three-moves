// ═══════════════════════════════════════════════════════════════════
// MoveSelector — 3 buttons, one per move. Teacher picks which move
// fits their class topic. Selection persists to ModuleProgress.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbCheck } from 'react-icons/tb';
import { MOVES } from '@/data/threeMoves';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import type { MoveKey } from '@/types/module.types';
import styles from './MoveSelector.module.scss';

const MoveSelector: React.FC = () => {
  const { progress, setPersonalMove } = useProgressCtx();
  const selected = progress.personalMove;

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.tag}>הבחירה שלכם</span>
        <h3 className={styles.title}>איזה מהלך מתאים לשיעור שאתם בונים?</h3>
        <p className={styles.lede}>
          תזכרו — כל מהלך מצוין בגיל מסוים, אבל אפשר להשתמש בכל אחד בכל גיל. בחרו לפי
          <strong> סוג הנושא</strong>, לא לפי שכבת הגיל.
        </p>
      </header>

      <ul className={styles.options}>
        {MOVES.map(m => {
          const active = selected === m.id;
          return (
            <li key={m.id}>
              <button
                type="button"
                onClick={() => setPersonalMove(m.id as MoveKey)}
                className={[
                  styles.option,
                  styles[`tint-${m.tint}`],
                  active && styles.optionActive,
                ].filter(Boolean).join(' ')}
                aria-pressed={active}
              >
                <header className={styles.optionHead}>
                  <span className={styles.optionNum}>מהלך {m.number}</span>
                  {active && (
                    <span className={styles.optionCheck} aria-label="נבחר">
                      <TbCheck aria-hidden />
                    </span>
                  )}
                </header>
                <h4 className={styles.optionName}>{m.nameHe}</h4>
                <p className={styles.optionPower}>{m.superpower}</p>
                <span className={styles.optionTransform}>
                  {m.transform.from} <span aria-hidden>←</span> <strong>{m.transform.to}</strong>
                </span>
              </button>
            </li>
          );
        })}
      </ul>
    </section>
  );
};

export default MoveSelector;