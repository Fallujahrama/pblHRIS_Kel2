<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class EmployeeSeeder extends Seeder
{
    public function run()
    {
        // Insert dummy departments
        DB::table('departments')->insert([
            ['id' => 1, 'name' => 'HRD'],
            ['id' => 2, 'name' => 'Keuangan'],
        ]);

        // Insert dummy positions
        DB::table('positions')->insert([
            ['id' => 1, 'name' => 'Manager'],
            ['id' => 2, 'name' => 'Staff'],
            ['id' => 3, 'name' => 'Supervisor'],
        ]);

        // Insert user dummy
        DB::table('users')->insert([
            [
                'email' => 'budi@example.com',
                'password' => Hash::make('password'),
                'is_admin' => false,
            ],
            [
                'email' => 'siti@example.com',
                'password' => Hash::make('password'),
                'is_admin' => false,
            ],
            [
                'email' => 'joko@example.com',
                'password' => Hash::make('password'),
                'is_admin' => false,
            ],
        ]);

        $budiId = DB::table('users')->where('email', 'budi@example.com')->value('id');
        $sitiId = DB::table('users')->where('email', 'siti@example.com')->value('id');
        $jokoId = DB::table('users')->where('email', 'joko@example.com')->value('id');

        DB::table('employees')->insert([
            [
                'user_id' => $budiId,
                'position_id' => 1,
                'department_id' => 1,
                'first_name' => 'Budi',
                'last_name' => 'Santoso',
                'gender' => 'L',
                'address' => 'Malang',
            ],
            [
                'user_id' => $sitiId,
                'position_id' => 2,
                'department_id' => 2,
                'first_name' => 'Siti',
                'last_name' => 'Aminah',
                'gender' => 'P',
                'address' => 'Surabaya',
            ],
            [
                'user_id' => $jokoId,
                'position_id' => 3,
                'department_id' => 1,
                'first_name' => 'Joko',
                'last_name' => 'Widodo',
                'gender' => 'L',
                'address' => 'Jakarta',
            ],
        ]);
        // Lookup inserted employee IDs to attach letters reliably
        $budiEmpId = DB::table('employees')->where('first_name', 'Budi')->where('last_name', 'Santoso')->value('id');
        $sitiEmpId = DB::table('employees')->where('first_name', 'Siti')->where('last_name', 'Aminah')->value('id');
        $jokoEmpId = DB::table('employees')->where('first_name', 'Joko')->where('last_name', 'Widodo')->value('id');

        // Dummy surat izin untuk setiap employee
            // Dummy surat izin (multiple entries, realistic timestamps/statuses)
            $formatIzinTidakMasuk = DB::table('letter_formats')->where('name', 'Surat Izin Tidak Masuk Kerja')->value('id') ?? 1;
            $formatSakit = DB::table('letter_formats')->where('name', 'Surat Sakit Tidak Masuk Kerja')->value('id') ?? 2;
            $formatTugas = DB::table('letter_formats')->where('name', 'Surat Tugas Bekerja di Luar Kantor')->value('id') ?? 3;

            DB::table('letters')->insert([
                // Budi: 2 requests
                [
                    'letter_format_id' => $formatIzinTidakMasuk,
                    'employee_id' => $budiEmpId,
                    'name' => 'Izin Sakit',
                    'jabatan' => 'Staff',
                    'departemen' => 'HRD',
                    'tanggal' => now()->toDateString(),
                    'status' => 'approved',
                    'created_at' => now()->subDays(10),
                    'updated_at' => now()->subDays(9),
                ],
                [
                    'letter_format_id' => $formatSakit,
                    'employee_id' => $budiEmpId,
                    'name' => 'Izin Cuti Tahunan',
                    'jabatan' => 'Staff',
                    'departemen' => 'HRD',
                    'tanggal' => now()->toDateString(),
                    'status' => 'approved',
                    'created_at' => now()->subDays(30),
                    'updated_at' => now()->subDays(29),
                ],

                // Siti: 1 request (pending)
                [
                    'letter_format_id' => $formatSakit,
                    'employee_id' => $sitiEmpId,
                    'name' => 'Izin Sakit (Surat Dokter)',
                    'jabatan' => 'Staff',
                    'departemen' => 'Keuangan',
                    'tanggal' => now()->toDateString(),
                    'status' => 'pending',
                    'created_at' => now()->subDays(5),
                    'updated_at' => now()->subDays(4),
                ],

                // Joko: 1 request (official task)
                [
                    'letter_format_id' => $formatTugas,
                    'employee_id' => $jokoEmpId,
                    'name' => 'Izin Tugas Luar Kota',
                    'jabatan' => 'Supervisor',
                    'departemen' => 'HRD',
                    'tanggal' => now()->toDateString(),
                    'status' => 'approved',
                    'created_at' => now()->subDays(2),
                    'updated_at' => now()->subDays(1),
                ],
            ]);
    }
}
