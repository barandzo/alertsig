import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavbarComponent } from '../../components/navbar/navbar.component';
import { CarteComponent } from '../../components/carte/carte.component';
import { AlerteZoneComponent } from '../../components/alerte-zone/alerte-zone.component';
import { FormulaireSignalementComponent } from '../../components/formulaire-signalement/formulaire-signalement.component';
import { ListeIncidentsComponent } from '../../components/liste-incidents/liste-incidents.component';

@Component({
  selector: 'app-accueil',
  standalone: true,
  imports: [
    CommonModule,
    NavbarComponent,
    CarteComponent,
    FormulaireSignalementComponent,
    AlerteZoneComponent,
  ListeIncidentsComponent  
  ],
  templateUrl: './accueil.component.html',
  styleUrl: './accueil.component.css'
})
export class AccueilComponent {
  showFormulaire = false;
  currentYear = new Date().getFullYear();

  ouvrirFormulaire(): void {
    this.showFormulaire = true;
  }

  fermerFormulaire(): void {
    this.showFormulaire = false;
  }
}