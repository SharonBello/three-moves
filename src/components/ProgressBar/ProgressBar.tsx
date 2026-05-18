// ═══════════════════════════════════════════════════════════════════
// ProgressBar — thin stripe at the very top of the module.
// Goes from 0% to 100% as sections are completed.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import styles from './ProgressBar.module.scss';

interface Props { percent: number; }

const ProgressBar: React.FC<Props> = ({ percent }) => (
  <div className={styles.track} aria-hidden>
    <div
      className={styles.fill}
      style={{ width: `${Math.max(0, Math.min(100, percent))}%` }}
    />
  </div>
);

export default ProgressBar;