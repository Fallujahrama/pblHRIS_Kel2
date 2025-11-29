<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\LetterFormatController;
use App\Http\Controllers\Api\LetterController;

// Ambil list template
Route::get('/letter-formats', [LetterFormatController::class, 'index']);
Route::get('/letter-formats/{id}', [LetterFormatController::class, 'show']);
Route::post('/letter-formats', [LetterFormatController::class, 'store']);
Route::put('/letter-formats/{id}', [LetterFormatController::class, 'update']);
Route::delete('/letter-formats/{id}', [LetterFormatController::class, 'destroy']);

// Create surat dari Flutter
Route::post('/letters', [LetterController::class, 'store']);
