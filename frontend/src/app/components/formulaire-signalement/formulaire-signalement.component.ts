import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IncidentService } from '../../services/incident.service';
import { TypeIncidentService } from '../../services/type-incident.service';
import { CarteEventService } from '../../services/carte-event.service';
import { TypeIncident } from '../../models/type-incident';

@Component({
  selector: 'app-formulaire-signalement',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './formulaire-signalement.component.html',
  styleUrl: './formulaire-signalement.component.css'
})
export class FormulaireSignalementComponent implements OnInit {
  @Output() fermer = new EventEmitter<void>();

  types: TypeIncident[] = [];
  selectedTypeId: number = 1;
  selectedSeverite: 1 | 2 | 3 = 2;
  titre: string = '';
  description: string = '';
  latitude: number | null = null;
  longitude: number | null = null;
  precision: number | null = null;
  loading: boolean = false;
  success: boolean = false;
  error: string = '';
  localisationEnCours: boolean = true;
  localisationErreur: boolean = false;

  constructor(
    private incidentService: IncidentService,
    private typeService: TypeIncidentService,
    private carteEventService: CarteEventService
  ) {}

  ngOnInit(): void {
    this.typeService.getAll().subscribe({
      next: types => {
        this.types = types;
        if (types.length > 0) this.selectedTypeId = types[0].id;
      }
    });
    this.getLocation();
  }

  getLocation(): void {
    this.localisationEnCours  = true;
    this.localisationErreur   = false;

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        pos => {
          this.latitude             = pos.coords.latitude;
          this.longitude            = pos.coords.longitude;
          this.precision            = pos.coords.accuracy;
          this.localisationEnCours  = false;
        },
        () => {
          // Position simulée si GPS refusé
          this.latitude            = 6.1375 + (Math.random() - 0.5) * 0.01;
          this.longitude           = 1.2123 + (Math.random() - 0.5) * 0.01;
          this.localisationEnCours = false;
          this.localisationErreur  = true;
        },
        { timeout: 10000, enableHighAccuracy: true }
      );
    } else {
      this.latitude            = 6.1375;
      this.longitude           = 1.2123;
      this.localisationEnCours = false;
      this.localisationErreur  = true;
    }
  }

  selectType(id: number): void {
    this.selectedTypeId = id;
  }

  selectSeverite(s: 1 | 2 | 3): void {
    this.selectedSeverite = s;
  }

  soumettre(): void {
    if (!this.latitude || !this.longitude) {
      this.error = 'Position GPS non disponible';
      return;
    }

    this.loading = true;
    this.error   = '';

    this.incidentService.create({
      type_id:       this.selectedTypeId,
      severite:      this.selectedSeverite,
      titre:         this.titre,
      description:   this.description,
      latitude:      this.latitude,
      longitude:     this.longitude,
      precision_gps: this.precision ?? undefined
    }).subscribe({
      next: () => {
        this.loading = false;
        this.success = true;

        // Recharge la carte automatiquement
        this.carteEventService.rechargerCarte();

        // Ferme le formulaire après 2 secondes
        setTimeout(() => {
          this.fermer.emit();
        }, 2000);
      },
      error: err => {
        this.loading = false;
        this.error = err.error?.message || 'Erreur lors du signalement';
      }
    });
  }

  fermerModal(): void {
    this.fermer.emit();
  }
}