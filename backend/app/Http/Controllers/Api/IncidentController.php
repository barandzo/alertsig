<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Incident;
use App\Models\TypeIncident;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Tymon\JWTAuth\Facades\JWTAuth;
use Illuminate\Support\Facades\DB;

class IncidentController extends Controller
{
    // LISTE TOUS LES INCIDENTS
    public function index(Request $request)
    {
        $query = DB::table('v_incidents_actifs');

        // Filtre par type
        if ($request->has('type')) {
            $query->where('type_code', $request->type);
        }

        // Filtre par statut
        if ($request->has('statut')) {
            $query->where('statut', $request->statut);
        }

        // Filtre zones critiques seulement
        if ($request->has('zone_critique')) {
            $query->where('est_zone_critique', true);
        }

        $incidents = $query->orderByDesc('created_at')->get();

        return response()->json($incidents);
    }

    // CRÉER UN SIGNALEMENT
    public function store(Request $request)
    {
        $request->validate([
            'type_id'     => 'required|exists:type_incident,id',
            'severite'    => 'required|in:1,2,3',
            'titre'       => 'nullable|string|max:200',
            'description' => 'nullable|string',
            'latitude'    => 'required|numeric|between:-90,90',
            'longitude'   => 'required|numeric|between:-180,180',
            'adresse'     => 'nullable|string',
            'quartier'    => 'nullable|string',
            'precision_gps' => 'nullable|numeric',
        ]);

        $user = JWTAuth::parseToken()->authenticate();

        // Crée le POINT PostGIS
        $position = DB::raw(
            "ST_SetSRID(ST_MakePoint({$request->longitude}, {$request->latitude}), 4326)"
        );

        $incident = Incident::create([
            'id'            => Str::uuid(),
            'type_id'       => $request->type_id,
            'severite'      => $request->severite,
            'titre'         => $request->titre,
            'description'   => $request->description,
            'position'      => $position,
            'adresse'       => $request->adresse,
            'quartier'      => $request->quartier,
            'precision_gps' => $request->precision_gps,
            'signale_par'   => $user->id,
            'statut'        => 'nouveau',
        ]);

        // Recharge avec les relations
        $incident->load('type', 'signalePar');

        return response()->json([
            'message'  => 'Incident signalé avec succès',
            'incident' => $incident
        ], 201);
    }

    // DÉTAIL D'UN INCIDENT
    public function show($id)
    {
        $incident = DB::table('v_incidents_actifs')
            ->where('id', $id)
            ->first();

        if (!$incident) {
            return response()->json(['message' => 'Incident non trouvé'], 404);
        }

        return response()->json($incident);
    }

    // INCIDENTS DANS UN RAYON (PostGIS)
    public function dansRayon(Request $request)
    {
        $request->validate([
            'latitude'  => 'required|numeric',
            'longitude' => 'required|numeric',
            'rayon'     => 'nullable|integer|max:10000',
        ]);

        $rayon = $request->rayon ?? 1000;

        $incidents = DB::select(
            'SELECT * FROM fn_incidents_rayon(?, ?, ?)',
            [$request->latitude, $request->longitude, $rayon]
        );

        return response()->json($incidents);
    }

    // EXPORT GEOJSON pour Leaflet
    public function geojson()
    {
        $geojson = DB::selectOne('SELECT fn_incidents_geojson() as data');
        return response()->json(json_decode($geojson->data));
    }

    // CHANGER LE STATUT (admin)
    public function changerStatut(Request $request, $id)
    {
        $request->validate([
            'statut' => 'required|in:nouveau,en_cours,resolu,rejete'
        ]);

        $user = JWTAuth::parseToken()->authenticate();

        if ($user->role !== 'admin' && $user->role !== 'superviseur') {
            return response()->json(['message' => 'Non autorisé'], 403);
        }

        $incident = Incident::findOrFail($id);
        $incident->update([
            'statut'             => $request->statut,
            'pris_en_charge_par' => $user->id,
        ]);

        return response()->json([
            'message'  => 'Statut mis à jour',
            'incident' => $incident
        ]);
    }

    // STATISTIQUES dashboard admin
    public function stats()
    {
        $stats = DB::selectOne('SELECT * FROM v_dashboard_admin');
        $parType = DB::select('SELECT * FROM v_stats_par_type');

        return response()->json([
            'dashboard' => $stats,
            'par_type'  => $parType
        ]);
    }
}