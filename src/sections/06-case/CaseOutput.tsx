// ═══════════════════════════════════════════════════════════════════
// CaseOutput — AI's response for Move 3 (Backwards from Case).
// 5 case cards + 12-value sort + 3 closing questions.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbCards, TbMessageQuestion } from 'react-icons/tb';
import { CASE_DEMO } from '@/data/moveDemos';
import styles from './CaseOutput.module.scss';

const CaseOutput: React.FC = () => (
  <section className={styles.section}>
    <header className={styles.head}>
      <span className={styles.tag}>הפלט של ה-AI</span>
      <h3 className={styles.title}>5 מקרים אמיתיים. 12 ערכים. שאלה אחת אישית.</h3>
      <p className={styles.lede}>
        אין "מסלול נכון" — יש <strong>ערכים</strong> שמובילים לבחירה. ה-AI לוקח 5 מקרים שונים,
        חולץ מהם את הערכים מתחת לפני השטח, ומציע פעילות שעוזרת לתלמיד לזהות אילו ערכים מובילים אותו.
      </p>
    </header>

    {/* 5 CASES */}
    <div className={styles.cases}>
      {CASE_DEMO.cases.map((c, i) => (
        <article key={i} className={styles.case}>
          <header className={styles.caseHead}>
            <span className={styles.caseNum}>מקרה {i + 1}</span>
            <h4 className={styles.casePath}>{c.path}</h4>
          </header>
          <p className={styles.caseOutcome}>{c.outcome}</p>
        </article>
      ))}
    </div>

    {/* VALUE CARDS */}
    <aside className={styles.values}>
      <header className={styles.valuesHead}>
        <TbCards aria-hidden />
        <div>
          <span className={styles.valuesTag}>פעילות · קלפי ערכים</span>
          <h4>12 ערכים — לסדר מהכי חשוב לפחות</h4>
        </div>
      </header>
      <ul className={styles.valueGrid} aria-label="ערכים מוצעים">
        {CASE_DEMO.values.map((v, i) => (
          <li key={i} className={styles.valueCard}>{v}</li>
        ))}
      </ul>
    </aside>

    {/* CLOSING QUESTIONS */}
    <aside className={styles.questions}>
      <header className={styles.questionsHead}>
        <TbMessageQuestion aria-hidden />
        <h4>3 שאלות סיכום</h4>
      </header>
      <ol className={styles.qList}>
        {CASE_DEMO.closingQuestions.map((q, i) => (
          <li key={i}>{q}</li>
        ))}
      </ol>
    </aside>
  </section>
);

export default CaseOutput;