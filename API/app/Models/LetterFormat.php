<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Support\Str;

class LetterFormat extends Model
{
    use HasFactory;
    
    protected $table = 'letter_formats';
    protected $fillable = ['name', 'content'];

    // Relasi ke letters
    public function letters()
    {
        return $this->hasMany(Letter::class, 'letter_format_id');
    }
}
