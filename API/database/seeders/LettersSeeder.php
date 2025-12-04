<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class LettersSeeder extends Seeder
{
    public function run()
    {
        // get some employees
        $employees = DB::table('employees')->select('id', 'first_name', 'last_name')->get();
        if ($employees->isEmpty()) {
            return;
        }

        // get formats
        $formats = DB::table('letter_formats')->pluck('id', 'name')->toArray();

        $now = now();

        $inserts = [];

        foreach ($employees as $index => $emp) {
            // create 1-2 letters per employee
            $count = ($index % 3 == 0) ? 2 : 1;
            for ($i = 0; $i < $count; $i++) {
                $format = null;
                if ($i === 0) {
                    $format = $formats['Surat Izin Tidak Masuk Kerja'] ?? array_values($formats)[0] ?? 1;
                } else {
                    $format = $formats['Surat Sakit Tidak Masuk Kerja'] ?? array_values($formats)[0] ?? 1;
                }

                $inserts[] = [
                    'letter_format_id' => $format,
                    'employee_id' => $emp->id,
                    'name' => ($i === 0) ? 'Izin Pribadi' : 'Izin Sakit',
                    'jabatan' => 'Staff',
                    'departemen' => 'General',
                    'tanggal' => $now->toDateString(),
                    'status' => ($i === 0) ? 'approved' : 'pending',
                    'created_at' => $now->copy()->subDays(rand(1, 40)),
                    'updated_at' => $now,
                ];
            }
        }

        if (!empty($inserts)) {
            DB::table('letters')->insert($inserts);
        }
    }
}
