<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TypeIncident;

class TypeIncidentController extends Controller
{
    public function index()
    {
        $types = TypeIncident::where('est_actif', true)
            ->orderBy('ordre')
            ->get();

        return response()->json($types);
    }
}