import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavbarComponent } from '../../components/navbar/navbar.component';
import { CarteComponent } from '../../components/carte/carte.component';
import { FormulaireSignalementComponent } from '../../components/formulaire-signalement/formulaire-signalement.component';

@Component({
  selector: 'app-accueil',
  standalone: true,
  imports: [
    CommonModule,
    NavbarComponent,
    CarteComponent,
    FormulaireSignalementComponent
  ],
  templateUrl: './accueil.component.html',
  styleUrl: './accueil.component.css'
})
export class AccueilComponent {
  showFormulaire = false;

  ouvrirFormulaire(): void {
    this.showFormulaire = true;
  }

  fermerFormulaire(): void {
    this.showFormulaire = false;
  }
}