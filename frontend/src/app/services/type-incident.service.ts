import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TypeIncident } from '../models/type-incident';

@Injectable({
  providedIn: 'root'
})
export class TypeIncidentService {
  private apiUrl = '/api/types';

  constructor(private http: HttpClient) {}

  getAll(): Observable<TypeIncident[]> {
    return this.http.get<TypeIncident[]>(this.apiUrl);
  }
}