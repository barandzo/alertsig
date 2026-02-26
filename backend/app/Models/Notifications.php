<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    protected $table = 'notifications';
    public $timestamps = false;

    protected $fillable = [
        'user_id', 'type', 'titre',
        'message', 'data_json', 'est_lue'
    ];

    protected $casts = [
        'est_lue'    => 'boolean',
        'data_json'  => 'array',
        'created_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}