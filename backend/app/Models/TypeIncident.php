<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TypeIncident extends Model
{
    protected $table = 'type_incident';
    public $timestamps = false;

    protected $fillable = [
        'code', 'libelle', 'emoji',
        'couleur_hex', 'icone_url',
        'seuil_zone_critique', 'est_actif', 'ordre'
    ];

    protected $casts = [
        'est_actif'           => 'boolean',
        'seuil_zone_critique' => 'integer',
        'ordre'               => 'integer',
    ];

    // Relations
    public function incidents()
    {
        return $this->hasMany(Incident::class, 'type_id');
    }
}