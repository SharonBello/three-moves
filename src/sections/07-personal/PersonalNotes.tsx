// ═══════════════════════════════════════════════════════════════════
// PersonalNotes — after running the prompt in AI, the teacher pastes
// the output here. Stored in localStorage; used by Section 8 for the
// personal lesson PDF.
// ═══════════════════════════════════════════════════════════════════
import React, { useEffect, useState } from 'react';
import { TbNotebook } from 'react-icons/tb';
import styles from './PersonalNotes.module.scss';

const STORAGE_KEY = 'binai.m04.personalNotes.v1';

function load(): string {
  try { return localStorage.getItem(STORAGE_KEY) ?? ''; } catch { return ''; }
}

const PersonalNotes: React.FC = () => {
  const [notes, setNotes] = useState(load);

  useEffect(() => {
    try { localStorage.setItem(STORAGE_KEY, notes); } catch { /* private mode */ }
  }, [notes]);

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.icon} aria-hidden><TbNotebook /></span>
        <div>
          <span className={styles.tag}>הפלט שלכם</span>
          <h3 className={styles.title}>הדביקו כאן את התשובה של ה-AI</h3>
          <p className={styles.lede}>
            הריצו את הפרומפט למעלה ב-ChatGPT / Claude / Gemini. העתיקו את התשובה ושמרו כאן —
            בחלק 8 (סיכום) זה ייכנס ל-PDF של השיעור שלכם.
          </p>
        </div>
      </header>

      <textarea
        className={styles.textarea}
        value={notes}
        onChange={e => setNotes(e.target.value)}
        rows={10}
        placeholder='הפלט מ-AI יודבק כאן. נשמר אוטומטית.'
      />
    </section>
  );
};

export default PersonalNotes;