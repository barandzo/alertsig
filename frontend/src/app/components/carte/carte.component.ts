import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import * as L from 'leaflet';
import { Subscription } from 'rxjs';
import { IncidentService } from '../../services/incident.service';
import { CarteEventService } from '../../services/carte-event.service';
import { Incident, IncidentGeoJSON } from '../../models/incident';
import { TypeIncidentService } from '../../services/type-incident.service';
import { FormsModule } from '@angular/forms';
import { ThemeService } from '../../services/theme.service';


@Component({
  selector: 'app-carte',
  standalone: true,
  imports: [CommonModule,FormsModule],
  templateUrl: './carte.component.html',
  styleUrl: './carte.component.css'
})
export class CarteComponent implements OnInit, OnDestroy {
  private map!: L.Map;
  private markersLayer!: L.LayerGroup;
  private zonesLayer!: L.LayerGroup;
  private rechargerSub!: Subscription;
  selectedIncident: Incident | null = null;
  monVote: string | null = null;
  votEnCours = false; 
  voteErreur = '';
  types: any[] = [];
 filtreType     = 'tous';
 filtreStatut   = 'tous';
 filtreSeverite = 'tous';
 tousLesFeatures: any[] = [];

  constructor(
    private incidentService: IncidentService,
    private carteEventService: CarteEventService,
    private typeService: TypeIncidentService,
    private themeService: ThemeService
  ) {}

  ngOnInit(): void {
    this.initMap();
    this.chargerIncidents();

    // Écoute les demandes de rechargement
    this.rechargerSub = this.carteEventService.recharger$.subscribe(() => {
      this.chargerIncidents();
    });

      // Écoute le zoom sur incident depuis la sidebar
  this.carteEventService.zoomSurIncident$.subscribe(incident => {
    this.map.setView([incident.latitude, incident.longitude], 17, { animate: true });
    this.selectedIncident = incident;
  });
  this.typeService.getAll().subscribe(types => this.types = types);
  }

  ngOnDestroy(): void {
    if (this.map) this.map.remove();
    if (this.rechargerSub) this.rechargerSub.unsubscribe();
  }

private initMap(): void {
  this.map = L.map('map', {
    center: [6.1375, 1.2123],
    zoom: 14,
    attributionControl: false 
  });

  this.majTuiles();
  this.markersLayer = L.layerGroup().addTo(this.map);
  this.zonesLayer   = L.layerGroup().addTo(this.map);

  // Change les tuiles quand le thème change
  this.themeService.theme$.subscribe(() => this.majTuiles());
}

private tuilesLayer?: L.TileLayer;

private majTuiles(): void {
  if (this.tuilesLayer) this.map.removeLayer(this.tuilesLayer);

  const url = this.themeService.getTheme() === 'dark'
    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
    : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';

  this.tuilesLayer = L.tileLayer(url, { maxZoom: 19 }).addTo(this.map);
}

chargerIncidents(): void {
  this.incidentService.getGeoJSON().subscribe({
    next: (geojson: IncidentGeoJSON) => {
      this.tousLesFeatures = geojson.features || [];
      this.appliquerFiltres();
    },
    error: err => console.error('Erreur chargement incidents', err)
  });
}

  fermerDetail(): void {
    this.selectedIncident = null;
  }

  getSeveriteLabel(s: number): string {
    return s === 3 ? '🔴 Critique' : s === 2 ? '🟠 Modéré' : '🟡 Faible';
  }

  getStatutLabel(s: string): string {
    return s === 'nouveau' ? '🆕 Nouveau' : s === 'en_cours' ? '⚙️ En cours' : '✅ Résolu';
  }

  getStatutClass(s: string): string {
    return s === 'nouveau' ? 'statut-nouveau' : s === 'en_cours' ? 'statut-en-cours' : 'statut-resolu';
  }

  chargerMonVote(incidentId: string): void {
  this.incidentService.getMonVote(incidentId).subscribe({
    next: data => this.monVote = data.vote
  });
}

voter(typeVote: 'confirmation' | 'infirmation'): void {
  if (!this.selectedIncident) return;

  this.votEnCours = true;
  this.voteErreur = '';

  this.incidentService.voter(this.selectedIncident.id, typeVote).subscribe({
    next: data => {
      this.votEnCours = false;
      this.monVote    = typeVote;

      // Met à jour les compteurs dans le panel
      if (this.selectedIncident) {
        this.selectedIncident.nb_confirmations = data.nb_confirmations;
        this.selectedIncident.nb_infirmations  = data.nb_infirmations;
        this.selectedIncident.score_confiance  = data.score_confiance;
      }
    },
    error: err => {
      this.votEnCours = false;
      this.voteErreur = err.error?.message || 'Erreur lors du vote';
    }
  });
}

appliquerFiltres(): void {
  this.markersLayer.clearLayers();
  this.zonesLayer.clearLayers();

  const featuresFiltres = this.tousLesFeatures.filter(feature => {
    const p = feature.properties;
    const typeOk     = this.filtreType     === 'tous' || p.type_code === this.filtreType;
    const statutOk   = this.filtreStatut   === 'tous' || p.statut    === this.filtreStatut;
    const severiteOk = this.filtreSeverite === 'tous' || p.severite  === +this.filtreSeverite;
    return typeOk && statutOk && severiteOk;
  });

  featuresFiltres.forEach(feature => {
    const props = feature.properties;
    const lat   = feature.geometry.coordinates[1];
    const lng   = feature.geometry.coordinates[0];

    if (props.est_zone_critique) {
      L.circle([lat, lng], {
        radius: 500,
        fillColor: '#ff3b3b',
        fillOpacity: 0.08,
        color: '#ff3b3b',
        weight: 1.5,
        dashArray: '6 4'
      }).addTo(this.zonesLayer);
    }

    const size    = props.severite === 3 ? 40 : props.severite === 2 ? 34 : 28;
    const glow    = props.severite === 3 ? '#ff3b3b' : props.severite === 2 ? '#ff7a00' : '#3b82f6';
    const resolved = props.statut === 'resolu';

    const icon = L.divIcon({
      html: `<div style="
        width:${size}px;height:${size}px;
        border-radius:50%;
        background:rgba(18,21,28,0.85);
        border:2px solid ${resolved ? '#00d4aa' : glow};
        display:flex;align-items:center;justify-content:center;
        font-size:${size * 0.45}px;
        box-shadow:0 0 ${props.severite * 6}px ${glow}60;
        cursor:pointer;
      ">${props.type_emoji}</div>`,
      className: '',
      iconAnchor: [size / 2, size / 2]
    });

    const marker = L.marker([lat, lng], { icon }).addTo(this.markersLayer);

    marker.on('click', () => {
      this.selectedIncident = props;
      this.monVote    = null;
      this.voteErreur = '';
      this.map.setView([lat, lng], 16, { animate: true });
      this.chargerMonVote(props.id);
    });
  });
}

changerFiltre(): void {
  this.appliquerFiltres();
}

reinitialiserFiltres(): void {
  this.filtreType     = 'tous';
  this.filtreStatut   = 'tous';
  this.filtreSeverite = 'tous';
  this.appliquerFiltres();
}
}