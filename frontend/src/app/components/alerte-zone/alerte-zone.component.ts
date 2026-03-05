import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule, DecimalPipe } from '@angular/common';
import { interval, Subscription } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { IncidentService } from '../../services/incident.service';

@Component({
  selector: 'app-alerte-zone',
  standalone: true,
  imports: [CommonModule, DecimalPipe],
  templateUrl: './alerte-zone.component.html',
  styleUrl: './alerte-zone.component.css'
})
export class AlerteZoneComponent implements OnInit, OnDestroy {
  zonesActives: any[] = [];
  alerteVisible = false;
  private pollSub!: Subscription;

  constructor(private incidentService: IncidentService) {}

  ngOnInit(): void {
    this.verifierZones();

    this.pollSub = interval(30000).pipe(
      switchMap(() => this.incidentService.getZonesCritiques())
    ).subscribe(data => this.traiterDonnees(data));
  }

  ngOnDestroy(): void {
    if (this.pollSub) this.pollSub.unsubscribe();
  }

  verifierZones(): void {
    this.incidentService.getZonesCritiques().subscribe({
      next: data => this.traiterDonnees(data),
      error: err => console.error('Erreur zones critiques', err)
    });
  }

  traiterDonnees(data: any): void {
    this.zonesActives = data.zones || [];

    // Affiche automatiquement si nouvelles zones
    if (this.zonesActives.length > 0) {
      this.alerteVisible = true;
    }
  }

  voirZoneSurGoogleMaps(zone: any): void {
    const url = `https://www.google.com/maps/dir/?api=1&destination=${zone.centre_lat},${zone.centre_lng}&travelmode=driving`;
    window.open(url, '_blank');
  }

  fermerAlerte(): void {
    this.alerteVisible = false;
  }
}