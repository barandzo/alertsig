export interface TypeIncident {
  id: number;
  code: string;
  libelle: string;
  emoji: string;
  couleur_hex: string;
  icone_url?: string;
  seuil_zone_critique: number;
  est_actif: boolean;
  ordre: number;
}
