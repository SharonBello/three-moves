// ═══════════════════════════════════════════════════════════════════
// PersonalPromptBuilder — once the teacher has picked a move AND
// filled their class (in Break section), we generate a personalized
// 4-part prompt and show it with a copy button.
// ═══════════════════════════════════════════════════════════════════
import React, { useMemo } from 'react';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import { MOVE_BY_ID } from '@/data/threeMoves';
import PromptDemo, { type FourPartPrompt } from '@/components/PromptDemo/PromptDemo';
import type { CustomTopic, MoveKey } from '@/types/module.types';
import styles from './PersonalPromptBuilder.module.scss';

// Templates per move — fill with the teacher's class data
function buildPrompt(move: MoveKey, topic: CustomTopic): FourPartPrompt {
  const ctxLine = `אני מחנכ/ת של ${topic.grade}. הנושא: ${topic.topic}.${topic.context ? ' ' + topic.context : ''}`;

  if (move === 'scenarios') {
    return {
      role: 'מומחה/ית להוראת חינוך. את/ה מתמחה בבניית סיפורים קצרים שעוזרים לתלמידים לדבר על הנושא בלי הטפה.',
      context: ctxLine,
      task: 'צור/י 3 סיפורים קצרים על תלמידים בני גיל זה שעוברים את הסיטואציה הזאת, כל אחד מסיבה שונה. שמות, פרטים, רגעים ספציפיים.',
      format: 'לכל סיפור עד 120 מילים + 4 שאלות לדיון. בסוף — פעילות סיכום אחת ל-15 דק׳ שמחברת את כל הסיפורים.',
    };
  }

  if (move === 'voices') {
    return {
      role: 'מומחה/ית להוראת חינוך. את/ה מתמחה בהצגת דילמות מ-3 פרספקטיבות, בלי "צד נכון".',
      context: ctxLine,
      task: 'תאר/י את אותו אירוע / דילמה מ-3 פרספקטיבות: (1) המורה מבחוץ, (2) תלמיד/ה שהשתתף/ה / ראה/תה, (3) הורה שמגלה אחר כך. כל קול בגוף ראשון, באוצר מילים מציאותי לגיל.',
      format: 'אחרי שלושת הקולות — פרוטוקול דיון "4 פינות": 4 עמדות אפשריות שתלמידים יכולים לזהות איתן, עם שאלה לכל עמדה.',
    };
  }

  return {
    role: 'מומחה/ית להוראת חינוך. את/ה מתמחה בדיונים ערכיים בלי לדחוף מסקנה אחת.',
    context: ctxLine,
    task: 'תאר/י 4-5 מקרים אמיתיים של בני אדם שהתמודדו עם הדילמה הזאת (כל אחד בחר אחרת). חלץ/י מהם את 3-4 הערכים המרכזיים שעמדו מאחורי הבחירות.',
    format: 'כרטיסיות מקרה (כל אחת ~100 מילים) + רשימת ערכים לפעילות מיון (10-12 ערכים) + 3 שאלות סיכום שמובילות לפעולה אישית.',
  };
}

const PersonalPromptBuilder: React.FC = () => {
  const { progress } = useProgressCtx();
  const move = progress.personalMove;
  const topic = progress.customTopic;

  const prompt = useMemo<FourPartPrompt | null>(() => {
    if (!move || !topic) return null;
    return buildPrompt(move, topic);
  }, [move, topic]);

  if (!move) {
    return (
      <aside className={styles.empty}>
        <p>בחרו מהלך למעלה כדי לראות את הפרומפט המותאם לכיתה שלכם.</p>
      </aside>
    );
  }

  if (!topic) {
    return (
      <aside className={styles.empty}>
        <p>נראה שלא מילאתם את פרטי הכיתה בחלק 4 (הפסקה). חזרו לשם, מלאו, וחזרו לכאן.</p>
      </aside>
    );
  }

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.tag}>הפרומפט שלכם</span>
        <h3 className={styles.title}>
          מותאם ל-<strong>{topic.grade}</strong> · {topic.topic}
        </h3>
        <p className={styles.lede}>
          מבוסס על <strong>{MOVE_BY_ID[move].nameHe}</strong>. העתיקו את הפרומפט המלא,
          הריצו אותו ב-AI, וקבלו פלט שאתם יכולים לקחת ישר לכיתה מחר.
        </p>
      </header>

      <PromptDemo prompt={prompt!} />
    </section>
  );
};

export default PersonalPromptBuilder;