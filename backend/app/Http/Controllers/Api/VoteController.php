<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\VoteIncident;
use App\Models\Incident;
use Illuminate\Http\Request;
use Tymon\JWTAuth\Facades\JWTAuth;

class VoteController extends Controller
{
    public function voter(Request $request, $incidentId)
    {
        $request->validate([
            'type_vote' => 'required|in:confirmation,infirmation'
        ]);

        $user = JWTAuth::parseToken()->authenticate();

        // Vérifie que l'incident existe
        $incident = Incident::findOrFail($incidentId);

        // Un utilisateur ne peut pas voter sur son propre incident
        if ($incident->signale_par === $user->id) {
            return response()->json([
                'message' => 'Vous ne pouvez pas voter sur votre propre signalement'
            ], 403);
        }

        // Vérifie si l'utilisateur a déjà voté
        $voteExistant = VoteIncident::where('incident_id', $incidentId)
            ->where('user_id', $user->id)
            ->first();

        if ($voteExistant) {
            // Change le vote si différent
            if ($voteExistant->type_vote === $request->type_vote) {
                return response()->json([
                    'message' => 'Vous avez déjà voté de cette façon'
                ], 409);
            }

            $voteExistant->update(['type_vote' => $request->type_vote]);

            return response()->json([
                'message'          => 'Vote modifié',
                'nb_confirmations' => $incident->fresh()->nb_confirmations,
                'nb_infirmations'  => $incident->fresh()->nb_infirmations,
                'score_confiance'  => $incident->fresh()->score_confiance,
            ]);
        }

        // Crée le vote
        VoteIncident::create([
            'incident_id' => $incidentId,
            'user_id'     => $user->id,
            'type_vote'   => $request->type_vote,
        ]);

        $incident->refresh();

        return response()->json([
            'message'          => 'Vote enregistré',
            'nb_confirmations' => $incident->nb_confirmations,
            'nb_infirmations'  => $incident->nb_infirmations,
            'score_confiance'  => $incident->score_confiance,
        ], 201);
    }

    public function monVote($incidentId)
    {
        $user = JWTAuth::parseToken()->authenticate();

        $vote = VoteIncident::where('incident_id', $incidentId)
            ->where('user_id', $user->id)
            ->first();

        return response()->json([
            'vote' => $vote?->type_vote ?? null
        ]);
    }
}