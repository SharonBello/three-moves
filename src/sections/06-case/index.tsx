// ═══════════════════════════════════════════════════════════════════
// Section 06 — מהלך 3 · מהמקרה אל הערך · תיכון (25 min)
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import MoveDemoIntro from '@/components/MoveDemoIntro/MoveDemoIntro';
import PromptDemo from '@/components/PromptDemo/PromptDemo';
import LessonPlanCard from '@/components/LessonPlanCard/LessonPlanCard';
import MoveReflection from '@/components/MoveReflection/MoveReflection';
import { MOVE_BY_ID } from '@/data/threeMoves';
import { CASE_DEMO } from '@/data/moveDemos';
import CaseOutput from './CaseOutput';

const CaseSection: React.FC = () => {
  const move = MOVE_BY_ID.case;
  return (
    <SectionShell id="case">
      <MoveDemoIntro
        move={move}
        demoTopic={CASE_DEMO.topic}
        gradeLabel={CASE_DEMO.grade}
      />

      <PromptDemo prompt={CASE_DEMO.prompt} />

      <CaseOutput />

      <LessonPlanCard
        totalMin={CASE_DEMO.plan.totalMin}
        blocks={CASE_DEMO.plan.blocks}
      />

      <MoveReflection
        question='איזה דילמה אצלכם בכיתה דורשת "מהמקרה אל הערך" — שיעור עם עומק, בלי תשובה אחת?'
        hint='לדוגמה: גיוס לפלוגות שונות, יחס למחויבות אזרחית, בחירת מסלולים אחרי שמינית.'
      />
    </SectionShell>
  );
};

export default CaseSection;