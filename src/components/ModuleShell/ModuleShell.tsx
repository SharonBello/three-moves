// ═══════════════════════════════════════════════════════════════════
// ModuleShell — the outermost wrapper.
// Hosts: NavBar + ProgressBar + the section <Outlet/>.
// Provides ModuleProgressContext to all descendants.
// ═══════════════════════════════════════════════════════════════════
import React from 'react';
import { Outlet } from 'react-router-dom';
import { useModuleProgress } from '@/hooks/useModuleProgress';
import NavBar from '@/components/NavBar/NavBar';
import ProgressBar from '@/components/ProgressBar/ProgressBar';
import { ModuleProgressContext } from './ModuleProgressContext';
import styles from './ModuleShell.module.scss';

const ModuleShell: React.FC = () => {
  const progressApi = useModuleProgress();

  return (
    <ModuleProgressContext.Provider value={progressApi}>
      <div className={styles.shell}>
        <ProgressBar percent={progressApi.percent} />
        <NavBar />

        <main className={styles.main}>
          <Outlet />
        </main>
      </div>
    </ModuleProgressContext.Provider>
  );
};

export default ModuleShell;