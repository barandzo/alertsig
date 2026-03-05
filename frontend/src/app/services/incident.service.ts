import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Incident, IncidentGeoJSON, CreateIncidentDto } from '../models/incident';

@Injectable({
  providedIn: 'root'
})
export class IncidentService {
  private apiUrl = '/api/incidents';

  constructor(private http: HttpClient) {}

  // Tous les incidents
  getAll(filters?: any): Observable<Incident[]> {
    let params = new HttpParams();
    if (filters?.type)          params = params.set('type', filters.type);
    if (filters?.statut)        params = params.set('statut', filters.statut);
    if (filters?.zone_critique) params = params.set('zone_critique', '1');
    return this.http.get<Incident[]>(this.apiUrl, { params });
  }

  // GeoJSON pour Leaflet
  getGeoJSON(): Observable<IncidentGeoJSON> {
    return this.http.get<IncidentGeoJSON>(`${this.apiUrl}/geojson`);
  }

  // Détail d'un incident
  getById(id: string): Observable<Incident> {
    return this.http.get<Incident>(`${this.apiUrl}/${id}`);
  }

  // Créer un signalement
  create(data: CreateIncidentDto): Observable<any> {
    return this.http.post(this.apiUrl, data);
  }

  // Incidents dans un rayon
  getDansRayon(lat: number, lng: number, rayon: number = 1000): Observable<any[]> {
    const params = new HttpParams()
      .set('latitude', lat)
      .set('longitude', lng)
      .set('rayon', rayon);
    return this.http.get<any[]>(`${this.apiUrl}/rayon`, { params });
  }

  // Changer le statut (admin)
  changerStatut(id: string, statut: string): Observable<any> {
    return this.http.put(`${this.apiUrl}/${id}/statut`, { statut });
  }

  // Stats dashboard
  getStats(): Observable<any> {
    return this.http.get(`${this.apiUrl}/stats/dashboard`);
  }



getZonesCritiques(): Observable<any> {
  return this.http.get(`/api/alertes/zones-critiques`);
}

voter(incidentId: string, typeVote: 'confirmation' | 'infirmation'): Observable<any> {
  return this.http.post(`${this.apiUrl}/${incidentId}/voter`, { type_vote: typeVote });
}

getMonVote(incidentId: string): Observable<any> {
  return this.http.get(`${this.apiUrl}/${incidentId}/mon-vote`);
}
}