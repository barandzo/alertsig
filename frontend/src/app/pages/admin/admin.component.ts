import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { IncidentService } from '../../services/incident.service';
import { AuthService } from '../../services/auth.service';
import { Incident } from '../../models/incident';

@Component({
  selector: 'app-admin',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './admin.component.html',
  styleUrl: './admin.component.css'
})
export class AdminComponent implements OnInit {
  incidents: Incident[] = [];
  stats: any = null;
  statsParType: any[] = [];
  loading = true;
  filtreStatut = 'tous';
  onglet: 'incidents' | 'stats' = 'incidents';

  constructor(
    private incidentService: IncidentService,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.chargerDonnees();
  }

  chargerDonnees(): void {
    this.loading = true;

    // Charge les incidents
    this.incidentService.getAll().subscribe({
      next: incidents => {
        this.incidents = incidents;
        this.loading   = false;
      }
    });

    // Charge les stats
    this.incidentService.getStats().subscribe({
      next: data => {
        this.stats       = data.dashboard;
        this.statsParType = data.par_type;
      }
    });
  }

  get incidentsFiltres(): Incident[] {
    if (this.filtreStatut === 'tous') return this.incidents;
    return this.incidents.filter(i => i.statut === this.filtreStatut);
  }

  changerStatut(id: string, statut: string): void {
    this.incidentService.changerStatut(id, statut).subscribe({
      next: () => this.chargerDonnees(),
      error: err => console.error(err)
    });
  }

  getSeveriteLabel(s: number): string {
    return s === 3 ? 'Critique' : s === 2 ? 'Modéré' : 'Faible';
  }

  getSeveriteClass(s: number): string {
    return s === 3 ? 'sev-critique' : s === 2 ? 'sev-moyen' : 'sev-faible';
  }

  getStatutClass(s: string): string {
    return s === 'nouveau' ? 'statut-nouveau' : s === 'en_cours' ? 'statut-en-cours' : 'statut-resolu';
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/login']);
  }

  voirSurCarte(lat: number, lng: number): void {
  const url = `https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}&travelmode=driving`;
  window.open(url, '_blank');
}
}