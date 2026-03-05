import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IncidentService } from '../../services/incident.service';
import { Incident } from '../../models/incident';
import { CarteEventService } from '../../services/carte-event.service';

@Component({
  selector: 'app-liste-incidents',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './liste-incidents.component.html',
  styleUrl: './liste-incidents.component.css'
})
export class ListeIncidentsComponent implements OnInit {
  @Output() incidentSelectionne = new EventEmitter<Incident>();

  incidents: Incident[] = [];
  filtreType   = 'tous';
  filtreStatut = 'tous';
  loading      = true;
  sidebarOuverte = false;

  constructor(private incidentService: IncidentService,private carteEventService: CarteEventService) {

  }

  ngOnInit(): void {
    this.chargerIncidents();
  }

  chargerIncidents(): void {
    this.loading = true;
    this.incidentService.getAll().subscribe({
      next: incidents => {
        this.incidents = incidents;
        this.loading   = false;
      }
    });
  }

  get incidentsFiltres(): Incident[] {
    return this.incidents.filter(i => {
      const typeOk   = this.filtreType   === 'tous' || i.type_code   === this.filtreType;
      const statutOk = this.filtreStatut === 'tous' || i.statut      === this.filtreStatut;
      return typeOk && statutOk;
    });
  }

  get typesUniques(): string[] {
    return [...new Set(this.incidents.map(i => i.type_code))];
  }

selectionner(incident: Incident): void {
  this.carteEventService.zoomSurIncident(incident);
  this.sidebarOuverte = false; // ferme la sidebar sur mobile
}

  getSeveriteClass(s: number): string {
    return s === 3 ? 'sev-critique' : s === 2 ? 'sev-moyen' : 'sev-faible';
  }

  getStatutClass(s: string): string {
    return s === 'nouveau' ? 'statut-nouveau' : s === 'en_cours' ? 'statut-en-cours' : 'statut-resolu';
  }

  toggleSidebar(): void {
    this.sidebarOuverte = !this.sidebarOuverte;
  }
}
