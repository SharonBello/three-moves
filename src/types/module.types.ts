// ═══════════════════════════════════════════════════════════════════
// M04 · Module Types
// 8 sections; each move pairs with one age tier.
// ═══════════════════════════════════════════════════════════════════

export type SectionId =
  | 'opening'    // 1 · the prep problem
  | 'theory'     // 2 · the 3 moves at a glance
  | 'scenarios'  // 3 · Move 1 (Scenario Generator) → יסודי demo
  | 'break'      // 4 · pick YOUR class for the personal lesson
  | 'voices'     // 5 · Move 2 (Three Voices) → חט"ב demo
  | 'case'       // 6 · Move 3 (Backwards from Case) → תיכון demo
  | 'personal'   // 7 · the teacher's own lesson
  | 'closing';   // 8 · 4 PDFs + final commitment

export type MoveKey = 'scenarios' | 'voices' | 'case';

export type AgeTier = 'elementary' | 'middle' | 'high';

export interface Section {
  id: SectionId;
  number: number;       // 1..8
  title: string;
  subtitle: string;
  durationMin: number;
  path: string;         // hash route e.g. '/scenarios'
}

export interface SectionState {
  id: SectionId;
  visited: boolean;
  completed: boolean;
}

// What the teacher entered in the Break section — for the personal lesson
export interface CustomTopic {
  subject: string;     // e.g. "חינוך"
  grade: string;       // e.g. "ז'"
  ageTier: AgeTier;    // elementary | middle | high
  topic: string;       // e.g. "תקרית בבוקר עם הקבוצה של שני"
  context?: string;    // optional notes about the class
}

export interface ModuleProgress {
  moduleId: 'm04';
  sections: Record<SectionId, SectionState>;
  completedAt: number | null;
  customTopic: CustomTopic | null;
  quizScore: number | null;
  /** Which move did the teacher pick for the personal lesson? */
  personalMove: MoveKey | null;
}