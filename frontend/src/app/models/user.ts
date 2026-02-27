export interface User {
  id: string;
  email: string;
  nom: string;
  prenom: string;
  telephone?: string;
  role: 'citoyen' | 'admin' | 'superviseur';
  score_fiabilite: number;
  nb_signalements: number;
  est_verifie: boolean;
  est_banni: boolean;
  created_at: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface RegisterDto {
  email: string;
  password: string;
  nom: string;
  prenom: string;
  telephone?: string;
}

export interface AuthResponse {
  message: string;
  user: User;
  token: string;
}