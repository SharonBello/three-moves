// ═══════════════════════════════════════════════════════════════════
// ModuleRouter — hash routing for iframe-safety.
// All 8 sections lazy-loaded; each is its own chunk.
// ═══════════════════════════════════════════════════════════════════
import React, { lazy, Suspense } from 'react';
import { createHashRouter, Navigate, RouterProvider } from 'react-router-dom';
import ModuleShell from '@/components/ModuleShell/ModuleShell';

const OpeningSection   = lazy(() => import('@/sections/01-opening'));
const TheorySection    = lazy(() => import('@/sections/02-theory'));
const ScenariosSection = lazy(() => import('@/sections/03-scenarios'));
const BreakSection     = lazy(() => import('@/sections/04-break'));
const VoicesSection    = lazy(() => import('@/sections/05-voices'));
const CaseSection      = lazy(() => import('@/sections/06-case'));
const PersonalSection  = lazy(() => import('@/sections/07-personal'));
const ClosingSection   = lazy(() => import('@/sections/08-closing'));

const withSuspense = (el: React.ReactNode) => (
  <Suspense fallback={null}>{el}</Suspense>
);

const router = createHashRouter([
  {
    path: '/',
    element: <ModuleShell />,
    children: [
      { index: true,        element: <Navigate to="/opening" replace /> },
      { path: 'opening',    element: withSuspense(<OpeningSection   />) },
      { path: 'theory',     element: withSuspense(<TheorySection    />) },
      { path: 'scenarios',  element: withSuspense(<ScenariosSection />) },
      { path: 'break',      element: withSuspense(<BreakSection     />) },
      { path: 'voices',     element: withSuspense(<VoicesSection    />) },
      { path: 'case',       element: withSuspense(<CaseSection      />) },
      { path: 'personal',   element: withSuspense(<PersonalSection  />) },
      { path: 'closing',    element: withSuspense(<ClosingSection   />) },
      { path: '*',          element: <Navigate to="/opening" replace /> },
    ],
  },
]);

const ModuleRouter: React.FC = () => <RouterProvider router={router} />;
export default ModuleRouter;