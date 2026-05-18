// ═══════════════════════════════════════════════════════════════════
// Section 02 — תיאוריה (Theory · 20 min)
// "שלושה מהלכים · מבט מהיר"
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import TheoryIntro from './TheoryIntro';
import MovesWorkbench from './MovesWorkbench';

const TheorySection: React.FC = () => (
  <SectionShell id="theory">
    <TheoryIntro />
    <MovesWorkbench />
  </SectionShell>
);

export default TheorySection;