<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Incident extends Model
{
    protected $table = 'incidents';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'type_id', 'severite', 'titre', 'description',
        'position', 'adresse', 'quartier', 'ville', 'pays',
        'precision_gps', 'statut', 'signale_par',
        'pris_en_charge_par', 'photos',
        'est_zone_critique', 'nb_incidents_proches'
    ];

    protected $casts = [
        'est_zone_critique'   => 'boolean',
        'photos'              => 'array',
        'severite'            => 'integer',
        'nb_confirmations'    => 'integer',
        'nb_infirmations'     => 'integer',
        'nb_incidents_proches'=> 'integer',
        'score_confiance'     => 'float',
        'created_at'          => 'datetime',
        'updated_at'          => 'datetime',
        'resolu_at'           => 'datetime',
    ];

    // Relations
    public function type()
    {
        return $this->belongsTo(TypeIncident::class, 'type_id');
    }

    public function signalePar()
    {
        return $this->belongsTo(User::class, 'signale_par');
    }

    public function prisEnChargePar()
    {
        return $this->belongsTo(User::class, 'pris_en_charge_par');
    }

    public function votes()
    {
        return $this->hasMany(VoteIncident::class, 'incident_id');
    }

    public function commentaires()
    {
        return $this->hasMany(CommentaireIncident::class, 'incident_id');
    }

    public function historique()
    {
        return $this->hasMany(HistoriqueStatut::class, 'incident_id');
    }

    // Accesseurs latitude / longitude
    public function getLatitudeAttribute()
    {
        if (!$this->position) return null;
        preg_match('/POINT\(([^ ]+) ([^ ]+)\)/', $this->position, $matches);
        return isset($matches[2]) ? (float) $matches[2] : null;
    }

    public function getLongitudeAttribute()
    {
        if (!$this->position) return null;
        preg_match('/POINT\(([^ ]+) ([^ ]+)\)/', $this->position, $matches);
        return isset($matches[1]) ? (float) $matches[1] : null;
    }
}