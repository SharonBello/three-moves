// ═══════════════════════════════════════════════════════════════════
// ScenariosOutput — the AI's response for Move 1.
// Three story cards (one per scenario) + closing activity card.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbMessageCircle, TbActivity } from 'react-icons/tb';
import { SCENARIO_DEMO } from '@/data/moveDemos';
import styles from './ScenariosOutput.module.scss';

// Discussion questions per story — same 4 per story (the prompt format
// asks for 4 per story; we keep one shared set for now since the workshop
// emphasizes the move pattern, not story-specific questions).
const DISCUSSION_QUESTIONS = [
  'מה הילד מרגיש לדעתכם? מה הסימנים שאפשר לראות מבחוץ?',
  'מי בכיתה כבר עבר משהו דומה? (בלי לציין שמות)',
  'מה היה עוזר לו ביום הראשון? מי היה צריך לעשות מהלך?',
  'אם זה היה עומק על מה שאתם רואים בכיתה — מה היינו עושים אחרת?',
];

const ScenariosOutput: React.FC = () => (
  <section className={styles.section}>
    <header className={styles.head}>
      <span className={styles.tag}>הפלט של ה-AI</span>
      <h3 className={styles.title}>3 סיפורים. אותו נושא, סיבות שונות.</h3>
      <p className={styles.lede}>
        ה-AI לא יודע את הילדים שלכם — אבל הוא מייצר סיפורים גנריים מספיק שהילדים יכולים
        להזדהות, וספציפיים מספיק שהם לא ירגישו "לימודיים".
      </p>
    </header>

    {/* STORIES */}
    <div className={styles.stories}>
      {SCENARIO_DEMO.stories.map((s, i) => (
        <article key={i} className={styles.story}>
          <header className={styles.storyHead}>
            <span className={styles.storyNum}>סיפור {i + 1}</span>
            <h4 className={styles.storyName}>{s.name}</h4>
            <span className={styles.storyCause}>{s.cause}</span>
          </header>
          <p className={styles.storyBody}>{s.preview}</p>
        </article>
      ))}
    </div>

    {/* DISCUSSION QUESTIONS — shared block */}
    <aside className={styles.discussion}>
      <header className={styles.discussionHead}>
        <TbMessageCircle aria-hidden />
        <h4>שאלות לדיון אחרי כל סיפור</h4>
      </header>
      <ol className={styles.qList}>
        {DISCUSSION_QUESTIONS.map((q, i) => (
          <li key={i}>{q}</li>
        ))}
      </ol>
    </aside>

    {/* ACTIVITY */}
    <aside className={styles.activity}>
      <header className={styles.activityHead}>
        <TbActivity aria-hidden />
        <div>
          <span className={styles.activityTag}>פעילות סיכום</span>
          <h4>{SCENARIO_DEMO.activity.name}</h4>
        </div>
        <span className={styles.activityTime}>{SCENARIO_DEMO.activity.duration}</span>
      </header>
      <ol className={styles.stepList}>
        {SCENARIO_DEMO.activity.steps.map((s, i) => (
          <li key={i}>{s}</li>
        ))}
      </ol>
    </aside>
  </section>
);

export default ScenariosOutput;