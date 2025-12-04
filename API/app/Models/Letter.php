<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Letter extends Model
{
    use HasFactory;

    protected $fillable = [
        'letter_format_id',
        'employee_id',
        'name',
        'jabatan',
        'departemen',
        'tanggal',
        'pdf_path',
        'status',
    ];

    protected $casts = [
        'tanggal' => 'date',
    ];

    // Relasi ke LetterFormat
    public function letterFormat()
    {
        return $this->belongsTo(LetterFormat::class);
    }

    // Relasi ke Employee
    public function employee()
    {
        return $this->belongsTo(Employee::class, 'employee_id');
    }
}
