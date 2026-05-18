// ═══════════════════════════════════════════════════════════════════
// PromptDemo — shows the 4-part prompt the workshop teaches.
// Reused by all 3 move-demo sections.
// Has a "copy whole prompt" button that joins the 4 parts into one block.
// ═══════════════════════════════════════════════════════════════════
import React, { useState } from 'react';
import { TbCopy, TbCheck } from 'react-icons/tb';
import styles from './PromptDemo.module.scss';

export interface FourPartPrompt {
  role:    string;
  context: string;
  task:    string;
  format:  string;
}

interface Props { prompt: FourPartPrompt; }

const LABELS: Record<keyof FourPartPrompt, { he: string; tag: string }> = {
  role:    { he: 'תפקיד',  tag: 'ROLE' },
  context: { he: 'קשר',    tag: 'CONTEXT' },
  task:    { he: 'משימה',  tag: 'TASK' },
  format:  { he: 'פורמט',  tag: 'FORMAT' },
};

function buildFullPrompt(p: FourPartPrompt): string {
  return [
    `תפקיד: ${p.role}`,
    `קשר: ${p.context}`,
    `משימה: ${p.task}`,
    `פורמט: ${p.format}`,
  ].join('\n\n');
}

const PromptDemo: React.FC<Props> = ({ prompt }) => {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    const text = buildFullPrompt(prompt);
    try {
      await navigator.clipboard.writeText(text);
      setCopied(true);
      setTimeout(() => setCopied(false), 1800);
    } catch {
      // Fallback: select+copy via temp textarea
      const ta = document.createElement('textarea');
      ta.value = text;
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand('copy'); setCopied(true); setTimeout(() => setCopied(false), 1800); }
      finally { document.body.removeChild(ta); }
    }
  };

  return (
    <section className={styles.section}>
      <header className={styles.head}>
        <span className={styles.tag}>הפרומפט</span>
        <h3 className={styles.title}>4 חלקים. תבנית קבועה.</h3>
        <p className={styles.lede}>
          העתיקו את הפרומפט המלא, הדביקו ב-ChatGPT/Claude/Gemini, ותקבלו את הפלט למטה.
        </p>
      </header>

      <ol className={styles.parts}>
        {(Object.keys(LABELS) as (keyof FourPartPrompt)[]).map((k) => (
          <li key={k} className={styles.part}>
            <header className={styles.partHead}>
              <span className={styles.partTag}>{LABELS[k].tag}</span>
              <span className={styles.partHe}>{LABELS[k].he}</span>
            </header>
            <p className={styles.partBody}>{prompt[k]}</p>
          </li>
        ))}
      </ol>

      <div className={styles.copyRow}>
        <button
          type="button"
          className={`${styles.copyBtn} ${copied ? styles.copyBtnDone : ''}`}
          onClick={handleCopy}
        >
          {copied ? <TbCheck aria-hidden /> : <TbCopy aria-hidden />}
          <span>{copied ? 'הועתק!' : 'העתיקו את הפרומפט המלא'}</span>
        </button>
      </div>
    </section>
  );
};

export default PromptDemo;