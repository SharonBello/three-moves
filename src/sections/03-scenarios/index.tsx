// ═══════════════════════════════════════════════════════════════════
// Section 03 — מהלך 1 · מחולל תרחישים · יסודי (25 min)
// Walks the teacher through: the move's superpower → the 4-part prompt
// → the AI output (3 stories + activity) → the 45-min lesson plan
// → a reflection on where else this move helps.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import MoveDemoIntro from '@/components/MoveDemoIntro/MoveDemoIntro';
import PromptDemo from '@/components/PromptDemo/PromptDemo';
import LessonPlanCard from '@/components/LessonPlanCard/LessonPlanCard';
import MoveReflection from '@/components/MoveReflection/MoveReflection';
import { MOVE_BY_ID } from '@/data/threeMoves';
import { SCENARIO_DEMO } from '@/data/moveDemos';
import ScenariosOutput from './ScenariosOutput';

const ScenariosSection: React.FC = () => {
  const move = MOVE_BY_ID.scenarios;
  return (
    <SectionShell id="scenarios">
      <MoveDemoIntro
        move={move}
        demoTopic={SCENARIO_DEMO.topic}
        gradeLabel={SCENARIO_DEMO.grade}
      />

      <PromptDemo prompt={SCENARIO_DEMO.prompt} />

      <ScenariosOutput />

      <LessonPlanCard
        totalMin={SCENARIO_DEMO.plan.totalMin}
        blocks={SCENARIO_DEMO.plan.blocks}
      />

      <MoveReflection
        question='איפה עוד במחזור החיים של הכיתה שלכם — מחולל תרחישים יעזור?'
        hint='לדוגמה: אנטי־בלינג, יום הזיכרון, פתיחת שנה, חזרה אחרי הפסקה ארוכה.'
      />
    </SectionShell>
  );
};

export default ScenariosSection;