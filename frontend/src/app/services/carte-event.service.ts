import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';
import { Incident } from '../models/incident';

@Injectable({
  providedIn: 'root'
})
export class CarteEventService {
  private rechargerSource = new Subject<void>();
  recharger$ = this.rechargerSource.asObservable();

  private zoomSurIncidentSource = new Subject<Incident>();
  zoomSurIncident$ = this.zoomSurIncidentSource.asObservable();

  rechargerCarte(): void {
    this.rechargerSource.next();
  }

  zoomSurIncident(incident: Incident): void {
    this.zoomSurIncidentSource.next(incident);
  }
}