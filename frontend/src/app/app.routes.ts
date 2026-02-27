import { Routes } from '@angular/router';
import { AccueilComponent } from './pages/accueil/accueil.component';
import { LoginComponent } from './pages/login/login.component';
import { AdminComponent } from './pages/admin/admin.component';
import { authGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { 
    path: '', 
    component: AccueilComponent,
    canActivate: [authGuard]      // ← protégé
  },
  { 
    path: 'admin', 
    component: AdminComponent,
    canActivate: [authGuard]      // ← protégé
  },
  { path: '**', redirectTo: '/login' }
];