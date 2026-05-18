// ═══════════════════════════════════════════════════════════════════
// VoicesOutput — AI's response for Move 2 (Three Voices).
// Three voice cards laid out vertically (each a different speaker)
// + the 4-corners discussion protocol card.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { TbCornerDownLeft, TbUsers } from 'react-icons/tb';
import { VOICES_DEMO } from '@/data/moveDemos';
import styles from './VoicesOutput.module.scss';

const VoicesOutput: React.FC = () => (
  <section className={styles.section}>
    <header className={styles.head}>
      <span className={styles.tag}>הפלט של ה-AI</span>
      <h3 className={styles.title}>אותו אירוע. שלוש זוויות.</h3>
      <p className={styles.lede}>
        AI לא מציע "נכון" או "לא נכון" — הוא מציג את אותו הסיפור משלוש פרספקטיבות. התלמידים
        שומעים מה הקול שהם לא היו חושבים עליו לבד.
      </p>
    </header>

    {/* THREE VOICES */}
    <div className={styles.voices}>
      {VOICES_DEMO.voices.map((v, i) => (
        <article key={i} className={styles.voice}>
          <header className={styles.voiceHead}>
            <span className={styles.voiceNum}>קול {i + 1}</span>
            <h4 className={styles.voiceWho}>{v.who}</h4>
            <span className={styles.voicePerspective}>{v.perspective}</span>
          </header>
          <blockquote className={styles.voiceBody}>{v.preview}</blockquote>
        </article>
      ))}
    </div>

    {/* 4 CORNERS PROTOCOL */}
    <aside className={styles.protocol}>
      <header className={styles.protocolHead}>
        <TbUsers aria-hidden />
        <div>
          <span className={styles.protocolTag}>פרוטוקול דיון</span>
          <h4>{VOICES_DEMO.protocol.name}</h4>
        </div>
        <span className={styles.protocolTime}>{VOICES_DEMO.protocol.duration}</span>
      </header>

      <p className={styles.protocolDesc}>{VOICES_DEMO.protocol.description}</p>

      <ul className={styles.corners}>
        {VOICES_DEMO.protocol.corners.map((c, i) => (
          <li key={i} className={styles.corner}>
            <span className={styles.cornerLabel}>
              <TbCornerDownLeft aria-hidden /> {c.label}
            </span>
            <p className={styles.cornerQ}>{c.q}</p>
          </li>
        ))}
      </ul>
    </aside>
  </section>
);

export default VoicesOutput;