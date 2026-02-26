<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ZoneSurveillance extends Model
{
    protected $table = 'zones_surveillance';
    public $timestamps = false;

    protected $fillable = [
        'nom', 'description', 'geom',
        'type_zone', 'seuil_alerte',
        'couleur_hex', 'opacite', 'est_active'
    ];

    protected $casts = [
        'est_active'    => 'boolean',
        'seuil_alerte'  => 'integer',
        'opacite'       => 'float',
        'created_at'    => 'datetime',
    ];
}