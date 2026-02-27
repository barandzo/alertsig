import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  mode: 'login' | 'register' = 'login';

  showPassword = false;

  // Login
  loginEmail    = '';
  loginPassword = '';

  // Register
  registerEmail     = '';
  registerPassword  = '';
  registerNom       = '';
  registerPrenom    = '';
  registerTelephone = '';

  loading = false;
  error   = '';
  success = '';

  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  connexion(): void {
    this.loading = true;
    this.error   = '';

    this.authService.login({
      email:    this.loginEmail,
      password: this.loginPassword
    }).subscribe({
      next: () => {
        this.loading = false;
        this.router.navigate(['/']);
      },
      error: err => {
        this.loading = false;
        this.error = err.error?.message || 'Email ou mot de passe incorrect';
      }
    });
  }

  inscription(): void {
    this.loading = true;
    this.error   = '';

    this.authService.register({
      email:     this.registerEmail,
      password:  this.registerPassword,
      nom:       this.registerNom,
      prenom:    this.registerPrenom,
      telephone: this.registerTelephone
    }).subscribe({
      next: () => {
        this.loading = false;
        this.success = 'Compte créé avec succès !';
        setTimeout(() => this.router.navigate(['/']), 1500);
      },
      error: err => {
        this.loading = false;
        this.error = err.error?.message || 'Erreur lors de l\'inscription';
      }
    });
  }
}