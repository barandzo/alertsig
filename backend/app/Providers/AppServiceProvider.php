<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        $platform = app('db')
            ->getDoctrineConnection()
            ->getDatabasePlatform();

        $platform->registerDoctrineTypeMapping('_text',    'string');
        $platform->registerDoctrineTypeMapping('_int4',    'integer');
        $platform->registerDoctrineTypeMapping('_float8',  'float');
        $platform->registerDoctrineTypeMapping('geometry', 'string');
        $platform->registerDoctrineTypeMapping('geography','string');
    }
}