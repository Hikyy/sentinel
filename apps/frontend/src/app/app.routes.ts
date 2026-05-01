import { Routes } from '@angular/router';

export const routes: Routes = [
    {
        path: '',
        pathMatch: 'full',
        redirectTo: 'events',
    },
    // Lazy-loaded features — à activer au fur et à mesure des modules
    // {
    //     path: 'events',
    //     loadChildren: () => import('./features/events/events.routes').then((m) => m.routes),
    // },
];
