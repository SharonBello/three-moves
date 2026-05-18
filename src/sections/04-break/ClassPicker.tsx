// ═══════════════════════════════════════════════════════════════════
// ClassPicker — form filled during Break section.
// Teacher enters: subject, grade, age tier, topic for their personal
// lesson. Stored in ModuleProgress.customTopic via context.
// canAdvance gate fires once all required fields are filled.
// ═══════════════════════════════════════════════════════════════════
import React, { useEffect, useState } from 'react';
import { TbSchool } from 'react-icons/tb';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import type { CustomTopic, AgeTier } from '@/types/module.types';
import styles from './ClassPicker.module.scss';

const AGE_OPTIONS: { value: AgeTier; label: string; emoji: string; gradeHint: string }[] = [
  { value: 'elementary', label: 'יסודי',  emoji: '🎒', gradeHint: 'א׳–ו׳' },
  { value: 'middle',     label: 'חט״ב',   emoji: '📱', gradeHint: 'ז׳–ט׳' },
  { value: 'high',       label: 'תיכון', emoji: '🎓', gradeHint: 'י׳–יב׳' },
];

interface Props {
  onValidityChange: (valid: boolean) => void;
}

const ClassPicker: React.FC<Props> = ({ onValidityChange }) => {
  const { progress, setCustomTopic } = useProgressCtx();
  const saved = progress.customTopic;

  const [subject, setSubject]   = useState(saved?.subject  ?? 'חינוך');
  const [grade,   setGrade]     = useState(saved?.grade    ?? '');
  const [ageTier, setAgeTier]   = useState<AgeTier | ''>(saved?.ageTier ?? '');
  const [topic,   setTopic]     = useState(saved?.topic    ?? '');
  const [context, setContext]   = useState(saved?.context  ?? '');

  // Validity & persistence
  useEffect(() => {
    const valid = !!(subject.trim() && grade.trim() && ageTier && topic.trim());
    onValidityChange(valid);
    if (valid) {
      const t: CustomTopic = {
        subject: subject.trim(),
        grade:   grade.trim(),
        ageTier: ageTier as AgeTier,
        topic:   topic.trim(),
        context: context.trim() || undefined,
      };
      setCustomTopic(t);
    }
  }, [subject, grade, ageTier, topic, context, onValidityChange, setCustomTopic]);

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.icon} aria-hidden><TbSchool /></span>
        <div>
          <span className={styles.tag}>הכיתה שלכם</span>
          <h3 className={styles.title}>איזה שיעור חינוך אתם בונים בשבוע הבא?</h3>
          <p className={styles.lede}>
            בחלק 7 (השיעור שלכם) — נשתמש בכיתה הזאת. אפשר תמיד לחזור ולערוך.
          </p>
        </div>
      </header>

      <div className={styles.fields}>
        <label className={styles.field}>
          <span className={styles.label}>מקצוע</span>
          <input
            type="text"
            value={subject}
            onChange={e => setSubject(e.target.value)}
            placeholder="חינוך"
            className={styles.input}
          />
        </label>

        <label className={styles.field}>
          <span className={styles.label}>כיתה</span>
          <input
            type="text"
            value={grade}
            onChange={e => setGrade(e.target.value)}
            placeholder='ז׳1 / ד׳ / יא׳ ...'
            className={styles.input}
          />
        </label>

        <fieldset className={styles.fieldset}>
          <legend className={styles.label}>שכבת גיל</legend>
          <div className={styles.ageRow}>
            {AGE_OPTIONS.map(opt => (
              <label
                key={opt.value}
                className={`${styles.ageOption} ${ageTier === opt.value ? styles.ageOptionActive : ''}`}
              >
                <input
                  type="radio"
                  name="ageTier"
                  value={opt.value}
                  checked={ageTier === opt.value}
                  onChange={() => setAgeTier(opt.value)}
                  className={styles.ageRadio}
                />
                <span className={styles.ageEmoji} aria-hidden>{opt.emoji}</span>
                <span className={styles.ageLabel}>{opt.label}</span>
                <span className={styles.ageHint}>{opt.gradeHint}</span>
              </label>
            ))}
          </div>
        </fieldset>

        <label className={styles.field}>
          <span className={styles.label}>נושא לשיעור</span>
          <input
            type="text"
            value={topic}
            onChange={e => setTopic(e.target.value)}
            placeholder='לדוג׳: תקרית בקבוצה / פתיחת שנה / יום השואה / בחירת מסלול'
            className={styles.input}
          />
        </label>

        <label className={styles.field}>
          <span className={styles.label}>הקשר נוסף <span className={styles.opt}>(אופציונלי)</span></span>
          <textarea
            value={context}
            onChange={e => setContext(e.target.value)}
            placeholder='מה כדאי שה-AI יידע על הכיתה? לדוגמה: רוב הבנות, כיתה רועשת, אחרי תקרית.'
            rows={3}
            className={styles.textarea}
          />
        </label>
      </div>
    </section>
  );
};

export default ClassPicker;