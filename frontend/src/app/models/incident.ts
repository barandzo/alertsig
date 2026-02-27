export interface Incident {
  id: string;
  titre: string;
  description: string;
  statut: 'nouveau' | 'en_cours' | 'resolu' | 'rejete';
  severite: 1 | 2 | 3;
  type_code: string;
  type_libelle: string;
  type_emoji: string;
  couleur_hex: string;
  latitude: number;
  longitude: number;
  adresse: string;
  quartier: string;
  ville: string;
  est_zone_critique: boolean;
  nb_incidents_proches: number;
  nb_confirmations: number;
  nb_infirmations: number;
  score_confiance: number;
  signale_par_nom: string;
  created_at: string;
  updated_at: string;
}

export interface IncidentGeoJSON {
  type: 'FeatureCollection';
  features: {
    type: 'Feature';
    geometry: {
      type: 'Point';
      coordinates: [number, number];
    };
    properties: Incident;
  }[];
}

export interface CreateIncidentDto {
  type_id: number;
  severite: 1 | 2 | 3;
  titre?: string;
  description?: string;
  latitude: number;
  longitude: number;
  adresse?: string;
  quartier?: string;
  precision_gps?: number;
}