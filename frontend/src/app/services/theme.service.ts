import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {
  private themeSubject = new BehaviorSubject<'dark' | 'light'>(
    (localStorage.getItem('theme') as 'dark' | 'light') || 'dark'
  );
  theme$ = this.themeSubject.asObservable();

  constructor() {
    this.appliquerTheme(this.themeSubject.value);
  }

  toggleTheme(): void {
    const nouveau = this.themeSubject.value === 'dark' ? 'light' : 'dark';
    this.themeSubject.next(nouveau);
    localStorage.setItem('theme', nouveau);
    this.appliquerTheme(nouveau);
  }

  getTheme(): 'dark' | 'light' {
    return this.themeSubject.value;
  }

  private appliquerTheme(theme: 'dark' | 'light'): void {
    document.body.setAttribute('data-theme', theme);
  }
}