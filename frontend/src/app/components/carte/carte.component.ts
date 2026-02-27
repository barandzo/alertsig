import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import * as L from 'leaflet';
import { IncidentService } from '../../services/incident.service';
import { Incident, IncidentGeoJSON } from '../../models/incident';

@Component({
  selector: 'app-carte',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './carte.component.html',
  styleUrl: './carte.component.css'
})
export class CarteComponent implements OnInit, OnDestroy {
  private map!: L.Map;
  private markersLayer!: L.LayerGroup;
  private zonesLayer!: L.LayerGroup;
  selectedIncident: Incident | null = null;

  constructor(private incidentService: IncidentService) {}

  ngOnInit(): void {
    this.initMap();
    this.chargerIncidents();
  }

  ngOnDestroy(): void {
    if (this.map) this.map.remove();
  }

  private initMap(): void {
    this.map = L.map('map', {
    center: [6.1375, 1.2123],
    zoom: 14,
      zoomControl: true
    });

    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
      maxZoom: 19
    }).addTo(this.map);

    this.markersLayer = L.layerGroup().addTo(this.map);
    this.zonesLayer   = L.layerGroup().addTo(this.map);
  }

  chargerIncidents(): void {
    this.incidentService.getGeoJSON().subscribe({
      next: (geojson: IncidentGeoJSON) => {
        this.markersLayer.clearLayers();
        this.zonesLayer.clearLayers();

        if (!geojson.features) return;

        geojson.features.forEach(feature => {
          const props = feature.properties;
          const lat   = feature.geometry.coordinates[1];
          const lng   = feature.geometry.coordinates[0];

          // Zone critique → cercle rouge
          if (props.est_zone_critique) {
            L.circle([lat, lng], {
              radius: 1000,
              fillColor: '#ff3b3b',
              fillOpacity: 0.08,
              color: '#ff3b3b',
              weight: 1.5,
              dashArray: '6 4'
            }).addTo(this.zonesLayer);
          }

          // Marqueur
          const size   = props.severite === 3 ? 40 : props.severite === 2 ? 34 : 28;
          const glow   = props.severite === 3 ? '#ff3b3b' : props.severite === 2 ? '#ff7a00' : '#3b82f6';
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

          const marker = L.marker([lat, lng], { icon })
            .addTo(this.markersLayer);

          marker.on('click', () => {
            this.selectedIncident = props;
          });
        });
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
    return s === 'nouveau' ? 'Nouveau' : s === 'en_cours' ? 'En cours' : 'Résolu';
  }
}