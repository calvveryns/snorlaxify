import { Routes } from '@angular/router';

export const routes: Routes = [
    {
        path: 'login',
        loadComponent: () => import('../pages/login/ui/login-page/login-page').then(m => m.LoginPage),
    }
];
