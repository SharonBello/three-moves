// ═══════════════════════════════════════════════════════════════════
// Section 05 — מהלך 2 · שלוש קולות · חט״ב (25 min)
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import SectionShell from '@/components/SectionShell/SectionShell';
import MoveDemoIntro from '@/components/MoveDemoIntro/MoveDemoIntro';
import PromptDemo from '@/components/PromptDemo/PromptDemo';
import LessonPlanCard from '@/components/LessonPlanCard/LessonPlanCard';
import MoveReflection from '@/components/MoveReflection/MoveReflection';
import { MOVE_BY_ID } from '@/data/threeMoves';
import { VOICES_DEMO } from '@/data/moveDemos';
import VoicesOutput from './VoicesOutput';

const VoicesSection: React.FC = () => {
  const move = MOVE_BY_ID.voices;
  return (
    <SectionShell id="voices">
      <MoveDemoIntro
        move={move}
        demoTopic={VOICES_DEMO.topic}
        gradeLabel={VOICES_DEMO.grade}
      />

      <PromptDemo prompt={VOICES_DEMO.prompt} />

      <VoicesOutput />

      <LessonPlanCard
        totalMin={VOICES_DEMO.plan.totalMin}
        blocks={VOICES_DEMO.plan.blocks}
      />

      <MoveReflection
        question='איזה אירוע בכיתה שלכם השנה היה צריך "שלוש קולות"?'
        hint='לדוגמה: ביקורת על מורה, ויכוח על ציון, הקנטה שלא הוכרה בזמן.'
      />
    </SectionShell>
  );
};

export default VoicesSection;