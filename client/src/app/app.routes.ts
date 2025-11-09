import { Routes } from '@angular/router';

export const routes: Routes = [
    {
        path: '',
        loadComponent: () => import('./layouts/shell/shell.layout').then(m => m.ShellLayout),
        children: [
            {
                path: '',
                pathMatch: 'full',
                redirectTo: 'processes'
            },
            {
                path: 'connections',
                loadComponent: () => import('../pages/connections-page/connections-page').then(m => m.ConnectionsPage),
            },
            {
                path: 'processes',
                loadComponent: () => import('../pages/processes-page/processes-page').then(m => m.ProcessesPage),
            },
            {
                path: 'processes/:id',
                loadComponent: () => import('../pages/process-detail-page/process-detail-page').then(m => m.ProcessDetailPage),
            }
        ]
    },
    {
        path: 'login',
        loadComponent: () => import('../pages/login/ui/login-page/login-page').then(m => m.LoginPage),
    }
];
