<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
 */

$router->get('/', function () use ($router) {
    return $router->app->version();
});

$router->get('/hello', function () use ($router) {
    return 'Hi';
});

$router->group(['prefix' => 'download'], function () use ($router) {
    $router->get('files', 'DownloadController@files');
    $router->get('export', 'DownloadController@export');
    $router->get('report', 'DownloadController@report');
    $router->get('/message', 'DownloadController@get_message');
});

$router->group(['prefix' => 'mail'], function () use ($router) {
    $router->post('password-reset', 'MailController@password_reset');
});

