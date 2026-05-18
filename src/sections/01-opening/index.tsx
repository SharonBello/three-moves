// ═══════════════════════════════════════════════════════════════════
// Section 01 — פתיחה
// "השיעור הכי משמעותי. הכנה מהירה"
// Frames the prep problem + introduces the deliverable (4 PDFs).
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import OpeningHero from './OpeningHero';
import PrepProblem from './PrepProblem';

const OpeningSection: React.FC = () => (
  <SectionShell id="opening">
    <OpeningHero />
    <PrepProblem />
  </SectionShell>
);

export default OpeningSection;