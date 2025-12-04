<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Employee;
use App\Models\Departement;
use App\Models\Position;

class EmployeeRecapController extends Controller
{
    public function index()
    {
        // Ambil data karyawan beserta departemen, posisi, letters dan user
        $employees = Employee::with(['department', 'position', 'letters', 'user'])->get();

        $recap = $employees->map(function ($employee) {
            return [
                'id' => $employee->id,
                'name' => $employee->first_name . ' ' . $employee->last_name,
                'department' => $employee->department ? $employee->department->name : null,
                'position' => $employee->position ? $employee->position->name : null,
                'gender' => $employee->gender,
                'address' => $employee->address,
                'email' => $employee->user ? $employee->user->email : null,
                'created_at' => $employee->created_at ? $employee->created_at->format('Y-m-d') : null,
                'letters' => $employee->letters->map(function ($letter) {
                    return [
                        'id' => $letter->id,
                        'name' => $letter->name,
                        'status' => $letter->status,
                    ];
                })->toArray(),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $recap
        ])->header('Access-Control-Allow-Origin', '*')
          ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
          ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    }
}
