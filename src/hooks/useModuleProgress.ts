// ═══════════════════════════════════════════════════════════════════
// useModuleProgress — single source of truth for the teacher's
// progress through M04. Persists to localStorage.
// ═══════════════════════════════════════════════════════════════════
import { useCallback, useEffect, useState } from 'react';
import { SECTIONS } from '@/data/sections';
import type {
  ModuleProgress,
  SectionId,
  CustomTopic,
  MoveKey,
} from '@/types/module.types';

const STORAGE_KEY = 'binai.m04.progress.v1';

function emptyProgress(): ModuleProgress {
  const sections = SECTIONS.reduce(
    (acc, s) => { acc[s.id] = { id: s.id, visited: false, completed: false }; return acc; },
    {} as ModuleProgress['sections'],
  );
  return {
    moduleId: 'm04',
    sections,
    completedAt: null,
    customTopic: null,
    quizScore: null,
    personalMove: null,
  };
}

function load(): ModuleProgress {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return emptyProgress();
    const parsed = JSON.parse(raw) as ModuleProgress;
    // Merge with empty in case schema gained new fields
    return { ...emptyProgress(), ...parsed,
      sections: { ...emptyProgress().sections, ...(parsed.sections ?? {}) }
    };
  } catch { return emptyProgress(); }
}

function save(p: ModuleProgress) {
  try { localStorage.setItem(STORAGE_KEY, JSON.stringify(p)); } catch { /* quota / private */ }
}

export function useModuleProgress() {
  const [progress, setProgress] = useState<ModuleProgress>(load);

  useEffect(() => { save(progress); }, [progress]);

  const visit = useCallback((id: SectionId) => {
    setProgress(p => ({
      ...p,
      sections: { ...p.sections, [id]: { ...p.sections[id], visited: true } },
    }));
  }, []);

  const complete = useCallback((id: SectionId) => {
    setProgress(p => ({
      ...p,
      sections: { ...p.sections, [id]: { ...p.sections[id], visited: true, completed: true } },
      completedAt: id === 'closing' ? Date.now() : p.completedAt,
    }));
  }, []);

  const setCustomTopic = useCallback((topic: CustomTopic) => {
    setProgress(p => ({ ...p, customTopic: topic }));
  }, []);

  const setQuizScore = useCallback((score: number) => {
    setProgress(p => ({ ...p, quizScore: score }));
  }, []);

  const setPersonalMove = useCallback((move: MoveKey) => {
    setProgress(p => ({ ...p, personalMove: move }));
  }, []);

  const reset = useCallback(() => setProgress(emptyProgress()), []);

  const completedCount = Object.values(progress.sections).filter(s => s.completed).length;
  const totalCount     = SECTIONS.length;
  const percent        = Math.round((completedCount / totalCount) * 100);

  return {
    progress,
    visit,
    complete,
    setCustomTopic,
    setQuizScore,
    setPersonalMove,
    reset,
    completedCount,
    totalCount,
    percent,
  };
}