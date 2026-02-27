import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CarteEventService {
  // Signal pour recharger les incidents sur la carte
  private rechargerSource = new Subject<void>();
  recharger$ = this.rechargerSource.asObservable();

  rechargerCarte(): void {
    this.rechargerSource.next();
  }
}