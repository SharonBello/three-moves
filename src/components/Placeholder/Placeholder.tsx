// ═══════════════════════════════════════════════════════════════════
// Placeholder — used by sections that haven't been built yet.
// Shows section meta + a friendly "coming soon" message.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbPencilOff } from 'react-icons/tb';
import SectionShell from '@/components/SectionShell/SectionShell';
import type { SectionId } from '@/types/module.types';
import styles from './Placeholder.module.scss';

interface Props { id: SectionId; }

const Placeholder: React.FC<Props> = ({ id }) => (
  <SectionShell id={id} canAdvance={false}>
    <div className={styles.empty}>
      <span className={styles.icon} aria-hidden><TbPencilOff /></span>
      <h3 className={styles.title}>חלק זה עוד לא נבנה</h3>
      <p>נחזור לבנות אותו ב-Phase הבאה. השאר עוגן בניווט למעלה.</p>
    </div>
  </SectionShell>
);

export default Placeholder;