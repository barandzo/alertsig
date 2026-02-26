<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\IncidentController;
use App\Http\Controllers\Api\TypeIncidentController;

// ── Auth (public) ──────────────────────────────
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login',    [AuthController::class, 'login']);
});

// ── Types (public) ─────────────────────────────
Route::get('types', [TypeIncidentController::class, 'index']);

// ── Incidents publics ──────────────────────────
Route::get('incidents',         [IncidentController::class, 'index']);
Route::get('incidents/geojson', [IncidentController::class, 'geojson']);
Route::get('incidents/rayon',   [IncidentController::class, 'dansRayon']);
Route::get('incidents/{id}',    [IncidentController::class, 'show']);

// ── Routes protégées (JWT requis) ──────────────
Route::middleware('auth:api')->group(function () {
    Route::post('auth/logout',  [AuthController::class, 'logout']);
    Route::get('auth/me',       [AuthController::class, 'me']);

    Route::post('incidents',                    [IncidentController::class, 'store']);
    Route::put('incidents/{id}/statut',         [IncidentController::class, 'changerStatut']);
    Route::get('incidents/stats/dashboard',     [IncidentController::class, 'stats']);
});