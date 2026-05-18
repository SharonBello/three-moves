// ═══════════════════════════════════════════════════════════════════
// ModuleRouter — hash routing for iframe-safety.
// Built sections use lazy() so each is its own chunk.
// ═══════════════════════════════════════════════════════════════════
import React, { lazy, Suspense } from 'react';
import { createHashRouter, Navigate, RouterProvider } from 'react-router-dom';
import ModuleShell from '@/components/ModuleShell/ModuleShell';
import Placeholder from '@/components/Placeholder/Placeholder';

const OpeningSection = lazy(() => import('@/sections/01-opening'));

const withSuspense = (el: React.ReactNode) => (
  <Suspense fallback={null}>{el}</Suspense>
);

const router = createHashRouter([
  {
    path: '/',
    element: <ModuleShell />,
    children: [
      { index: true,        element: <Navigate to="/opening" replace /> },
      { path: 'opening',    element: withSuspense(<OpeningSection />) },
      { path: 'theory',     element: <Placeholder id="theory"    /> },
      { path: 'scenarios',  element: <Placeholder id="scenarios" /> },
      { path: 'break',      element: <Placeholder id="break"     /> },
      { path: 'voices',     element: <Placeholder id="voices"    /> },
      { path: 'case',       element: <Placeholder id="case"      /> },
      { path: 'personal',   element: <Placeholder id="personal"  /> },
      { path: 'closing',    element: <Placeholder id="closing"   /> },
      { path: '*',          element: <Navigate to="/opening" replace /> },
    ],
  },
]);

const ModuleRouter: React.FC = () => <RouterProvider router={router} />;
export default ModuleRouter;