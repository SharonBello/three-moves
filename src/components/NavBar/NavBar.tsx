// ═══════════════════════════════════════════════════════════════════
// NavBar — top of the page.
// Brand on the right (RTL), 8 section circles on the left.
// Sketchbook aesthetic: handwritten accents, soft paper background.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { SECTIONS } from '@/data/sections';
import { useProgressCtx } from '@/components/ModuleShell/ModuleProgressContext';
import styles from './NavBar.module.scss';

const NavBar: React.FC = () => {
  const { progress } = useProgressCtx();
  const { pathname, hash } = useLocation();
  const currentPath = hash.replace('#', '') || pathname;

  return (
    <nav className={styles.nav} aria-label="ניווט בין חלקי המודול">
      <div className={styles.brand}>
        <span className={styles.brandTag}>M04</span>
        <span className={styles.brandTitle}>שלושה מהלכים</span>
      </div>

      <ol className={styles.dots}>
        {SECTIONS.slice().reverse().map((s) => {
          const state = progress.sections[s.id];
          const active = currentPath === s.path;
          const completed = state.completed;
          const visited = state.visited;
          return (
            <li key={s.id}>
              <Link
                to={s.path}
                className={[
                  styles.dot,
                  active && styles.dotActive,
                  completed && styles.dotDone,
                  !active && !completed && visited && styles.dotVisited,
                ].filter(Boolean).join(' ')}
                aria-current={active ? 'page' : undefined}
                aria-label={`${s.number}. ${s.title} — ${s.subtitle}`}
                title={`${s.number}. ${s.title} · ${s.subtitle}`}
              >
                {s.number}
              </Link>
            </li>
          );
        })}
      </ol>
    </nav>
  );
};

export default NavBar;