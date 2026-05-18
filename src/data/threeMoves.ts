// ═══════════════════════════════════════════════════════════════════
// M04 · Three Moves Data
// The 3 reusable patterns for AI-assisted shiur chinuch prep.
// Each one pairs with the age tier where its value is most striking,
// but ALL three can be used at any age — the age pairing is pedagogical
// fit, not a hard rule.
// ═══════════════════════════════════════════════════════════════════
import type { MoveKey, AgeTier } from '@/types/module.types';

export interface Move {
  id: MoveKey;
  number: 1 | 2 | 3;
  nameHe: string;
  nameEn: string;
  /** The age tier where this move shines. */
  bestFor: { tier: AgeTier; label: string; emoji: string };
  /** One-line punch — what AI does that you couldn't easily do alone. */
  superpower: string;
  /** 1-2 sentence description with concrete framing. */
  description: string;
  /** "before → after" — the transformation in one phrase. */
  transform: { from: string; to: string };
  /** A one-line demo topic that this move will be applied to in its section. */
  demoTopic: string;
  /** Visual tint for the card. */
  tint: 'yellow' | 'blue' | 'red';
}

export const MOVES: Move[] = [
  {
    id: 'scenarios',
    number: 1,
    nameHe: 'מחולל תרחישים',
    nameEn: 'Scenario Generator',
    bestFor: { tier: 'elementary', label: 'יסודי', emoji: '🎒' },
    superpower: 'הופך נושא מופשט לסיפורים שילדים מתחברים אליהם.',
    description:
      'במקום ללמד על "כבוד" — סיפור על ילד שגנבו לו את הכובע. הסיפור עושה את העבודה. AI מייצר אותם בקצב שלכם.',
    transform: { from: 'מופשט', to: '3 סיפורים קונקרטיים' },
    demoTopic: 'הילד שיושב לבד בהפסקה · כיתה ד׳',
    tint: 'yellow',
  },
  {
    id: 'voices',
    number: 2,
    nameHe: 'שלוש קולות',
    nameEn: 'Three Voices',
    bestFor: { tier: 'middle', label: 'חט״ב', emoji: '📱' },
    superpower: 'מציג את אותו אירוע משלוש פרספקטיבות: מורה · תלמיד · הורה.',
    description:
      'בגיל הזה התלמידים בעיקר רואים את עצמם. AI עוזר להציג גם את הקול של האחר — של ההורה, של המורה, של מי שנפגע — בלי הטפה.',
    transform: { from: 'נקודת מבט אחת', to: '3 פרספקטיבות' },
    demoTopic: 'רכילות בקבוצת WhatsApp · כיתה ח׳',
    tint: 'blue',
  },
  {
    id: 'case',
    number: 3,
    nameHe: 'מהמקרה אל הערך',
    nameEn: 'Backwards from Case',
    bestFor: { tier: 'high', label: 'תיכון', emoji: '🎓' },
    superpower: 'מתחיל ממקרה אמיתי, מחלץ את העיקרון, ובונה דיון עמוק.',
    description:
      'תלמידי תיכון מזהים סיסמאות מקילומטר. AI מתחיל מסיפור אמיתי (חדשות, מקרה אישי) ועוזר לחשוף את השאלה הגדולה שמתחתיו — בלי להגיש תשובה.',
    transform: { from: 'אירוע יחיד', to: 'שאלה ערכית' },
    demoTopic: 'חיים אחרי הצבא · כיתה י״ב',
    tint: 'red',
  },
];

export const MOVE_BY_ID: Record<MoveKey, Move> = MOVES.reduce(
  (acc, m) => { acc[m.id] = m; return acc; },
  {} as Record<MoveKey, Move>,
);