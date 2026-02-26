<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VoteIncident extends Model
{
    protected $table = 'votes_incidents';
    public $timestamps = false;

    protected $fillable = [
        'incident_id', 'user_id',
        'type_vote', 'commentaire'
    ];

    protected $casts = [
        'created_at' => 'datetime',
    ];

    public function incident()
    {
        return $this->belongsTo(Incident::class, 'incident_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}