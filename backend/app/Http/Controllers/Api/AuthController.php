<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Facades\JWTAuth;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    // INSCRIPTION
public function register(Request $request)
{
    $request->validate([
        'email'     => 'required|email|unique:users,email',
        'password'  => 'required|min:6',
        'nom'       => 'required|string',
        'prenom'    => 'required|string',
        'telephone' => 'nullable|string',
    ]);

    $uuid = (string) Str::uuid();

    User::insert([
        'id'            => $uuid,
        'email'         => $request->email,
        'password_hash' => Hash::make($request->password),
        'nom'           => $request->nom,
        'prenom'        => $request->prenom,
        'telephone'     => $request->telephone,
        'role'          => 'citoyen',
        'est_verifie'   => true,
        'score_fiabilite' => 100,
        'nb_signalements' => 0,
        'nb_confirmations' => 0,
        'nb_faux_positifs' => 0,
        'est_banni'     => false,
        'created_at'    => now(),
        'updated_at'    => now(),
    ]);

    // Recharge depuis la base avec Eloquent
    $user = User::where('id', $uuid)->first();

    if (!$user) {
        return response()->json(['message' => 'Erreur création utilisateur'], 500);
    }

    $token = JWTAuth::fromUser($user);

    return response()->json([
        'message' => 'Inscription réussie',
        'user'    => $user,
        'token'   => $token
    ], 201);
}

    // CONNEXION
    public function login(Request $request)
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password_hash)) {
            return response()->json([
                'message' => 'Email ou mot de passe incorrect'
            ], 401);
        }

        if ($user->est_banni) {
            return response()->json([
                'message' => 'Compte suspendu'
            ], 403);
        }

        $token = JWTAuth::fromUser($user);

        return response()->json([
            'message' => 'Connexion réussie',
            'user'    => [
                'id'              => $user->id,
                'nom'             => $user->nom,
                'prenom'          => $user->prenom,
                'email'           => $user->email,
                'role'            => $user->role,
                'score_fiabilite' => $user->score_fiabilite,
            ],
            'token' => $token
        ]);
    }

    // PROFIL CONNECTÉ
    public function me()
    {
        $user = JWTAuth::parseToken()->authenticate();
        return response()->json($user);
    }

    // DÉCONNEXION
    public function logout()
    {
        JWTAuth::invalidate(JWTAuth::getToken());
        return response()->json(['message' => 'Déconnexion réussie']);
    }
}