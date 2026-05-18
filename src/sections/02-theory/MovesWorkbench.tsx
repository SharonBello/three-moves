// ═══════════════════════════════════════════════════════════════════
// MovesWorkbench — the 3 moves laid out like tools on a workbench.
// Each card is tilted at a slightly different angle for organic feel.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { MOVES } from '@/data/threeMoves';
import MoveCard from './MoveCard';
import styles from './MovesWorkbench.module.scss';

const ROTATIONS = ['-1.5deg', '1deg', '-0.8deg'];

const MovesWorkbench: React.FC = () => (
  <section className={styles.workbench} aria-label="שלושת המהלכים">
    <ul className={styles.grid}>
      {MOVES.map((m, i) => (
        <li
          key={m.id}
          className={styles.cell}
          style={{ '--rot': ROTATIONS[i % ROTATIONS.length] } as React.CSSProperties}
        >
          <MoveCard move={m} />
        </li>
      ))}
    </ul>
  </section>
);

export default MovesWorkbench;