// ═══════════════════════════════════════════════════════════════════
// ModuleProgressContext — exposes useModuleProgress to all sections
// without prop-drilling.
// ═══════════════════════════════════════════════════════════════════
import { createContext, useContext } from 'react';
import { useModuleProgress } from '@/hooks/useModuleProgress';

type Ctx = ReturnType<typeof useModuleProgress>;

export const ModuleProgressContext = createContext<Ctx | null>(null);

export function useProgressCtx() {
  const ctx = useContext(ModuleProgressContext);
  if (!ctx) throw new Error('useProgressCtx must be inside a ModuleProgressContext.Provider');
  return ctx;
}