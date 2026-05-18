// ═══════════════════════════════════════════════════════════════════
// Section 07 — השיעור שלך · מהלך אחד · הכיתה שלך (30 min)
// Three parts:
//   1. Pick a move (MoveSelector)
//   2. See the personalized 4-part prompt (PersonalPromptBuilder)
//   3. Run it in AI and capture what you got (PersonalNotes)
// Next button gated on having selected a move.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import MoveSelector from './MoveSelector';
import PersonalPromptBuilder from './PersonalPromptBuilder';
import PersonalNotes from './PersonalNotes';

const PersonalSection: React.FC = () => {
  const { progress } = useProgressCtx();
  const canAdvance = progress.personalMove !== null;

  return (
    <SectionShell id="personal" canAdvance={canAdvance}>
      <MoveSelector />
      <PersonalPromptBuilder />
      <PersonalNotes />
    </SectionShell>
  );
};

export default PersonalSection;