// ═══════════════════════════════════════════════════════════════════
// M04 · Lesson Types
// The 4 PDFs the teacher leaves with:
//   3 demo lessons (one per age tier, co-built through workshop)
//   1 personal lesson (their own class)
// ═══════════════════════════════════════════════════════════════════

import type { MoveKey, AgeTier } from './module.types';

export interface LessonPlanFields {
  /** Auto-filled */
  subject: string;       // מקצוע
  grade: string;         // כיתה
  topic: string;         // נושא
  duration: string;      // משך — usually "45 דק'"
  /** Free-form by teacher */
  goals: string;         // מטרות
  openingHook: string;   // פתיח (Engage)
  body: string;          // גוף השיעור
  discussion: string;    // דיון / שאלות מנחות
  closure: string;       // סיכום
  takeaway: string;      // מה לוקחים הביתה
}

/** Which "move" was used to generate this lesson — drives the PDF subtitle */
export interface LessonPlan extends LessonPlanFields {
  generatedBy: MoveKey;
  ageTier: AgeTier;
}