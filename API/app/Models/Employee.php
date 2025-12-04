<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Employee extends Model
{
    protected $table = 'employees';
    protected $fillable = [
        'user_id',
        'position_id',
        'department_id',
        'first_name',
        'last_name',
        'gender',
        'address'
    ];

    // Relasi ke Department (note: model class is `Departement` in this repo)
    public function department()
    {
        return $this->belongsTo(Departement::class, 'department_id');
    }

    // Relasi ke Position
    public function position()
    {
        return $this->belongsTo(Position::class, 'position_id');
    }

    // Relasi ke Letters
    public function letters()
    {
        return $this->hasMany(Letter::class, 'employee_id');
    }

    // Relasi ke User
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
