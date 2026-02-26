<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    protected $table = 'users';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'email', 'password_hash', 'nom', 'prenom',
        'telephone', 'role', 'est_verifie',
        'score_fiabilite', 'est_banni'
    ];

    protected $hidden = [
        'password_hash', 'token_verif'
    ];

    protected $casts = [
        'est_verifie' => 'boolean',
        'est_banni'   => 'boolean',
        'created_at'  => 'datetime',
        'updated_at'  => 'datetime',
    ];

    // JWT requis
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    // Relations
    public function incidents()
    {
        return $this->hasMany(Incident::class, 'signale_par');
    }

    public function votes()
    {
        return $this->hasMany(VoteIncident::class, 'user_id');
    }
}