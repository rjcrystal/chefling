<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->group(function (){
    Route::get('user/profile','UserController@profile');
    Route::patch('user/profile/update','UserController@update');
});

Route::post('user/signup','AuthController@register');
Route::post('user/signin','AuthController@login');