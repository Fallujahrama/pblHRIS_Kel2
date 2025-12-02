<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Letter;
use App\Models\LetterFormat;
use Illuminate\Http\Request;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class LetterController extends Controller
{
    // GET all letters
    public function index()
    {
        try {
            $letters = Letter::with('letterFormat')->orderBy('created_at', 'desc')->get();

            return response()->json([
                'success' => true,
                'data' => $letters
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // POST create letter
    public function store(Request $request)
    {
        try {
            $request->validate([
                'letter_format_id' => 'required|exists:letter_formats,id',
                'name' => 'required|string|max:100',
                'jabatan' => 'required|string|max:100',
                'departemen' => 'required|string|max:100',
                'tanggal' => 'required|date',
            ]);

            $letter = Letter::create([
                'letter_format_id' => $request->letter_format_id,
                'name' => $request->name,
                'jabatan' => $request->jabatan,
                'departemen' => $request->departemen,
                'tanggal' => $request->tanggal,
                'status' => 'pending', // default
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Surat berhasil diajukan',
                'data' => $letter->load('letterFormat')
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // GET single letter
    public function show($id)
    {
        try {
            $letter = Letter::with('letterFormat')->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $letter
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Letter tidak ditemukan'
            ], 404);
        }
    }

    // PUT update status (untuk HRD approve/reject)
    public function updateStatus(Request $request, $id)
    {
        try {
            $letter = Letter::findOrFail($id);

            $request->validate([
                'status' => 'required|in:approved,rejected',
            ]);

            $letter->update([
                'status' => $request->status,
            ]);

            // Jika approve, generate PDF
            if ($request->status === 'approved' && !$letter->pdf_path) {
                $this->generatePdf($letter);
            }

            return response()->json([
                'success' => true,
                'message' => 'Status berhasil diupdate',
                'data' => $letter->load('letterFormat')
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // Helper: Generate PDF dan simpan ke storage
    private function generatePdf(Letter $letter)
    {
        try {
            // Gunakan dompdf untuk generate PDF di backend
            $pdf = Pdf::loadView('letters.template', [
                'letter' => $letter,
                'letterFormat' => $letter->letterFormat,
            ]);

            // Buat nama file
            $filename = 'surat_' . $letter->id . '_' . now()->timestamp . '.pdf';
            $path = 'letters/' . $filename;

            // Simpan ke storage
            Storage::disk('public')->put($path, $pdf->output());

            // Update letter dengan path PDF
            $letter->update(['pdf_path' => $path]);

            return $path;
        } catch (\Exception $e) {
            Log::error('PDF Generation Error: ' . $e->getMessage());
            throw $e;
        }
    }

    // DELETE letter
    public function destroy($id)
    {
        try {
            $letter = Letter::findOrFail($id);
            $letter->delete();

            return response()->json([
                'success' => true,
                'message' => 'Letter berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // GET download PDF
    public function downloadPdf($id)
    {
        try {
            $letter = Letter::findOrFail($id);

            if (!$letter->pdf_path || !Storage::disk('public')->exists($letter->pdf_path)) {
                return response()->json([
                    'success' => false,
                    'message' => 'PDF tidak ditemukan'
                ], 404);
            }

            $filePath = Storage::disk('public')->path($letter->pdf_path);
            return response()->download($filePath, 'surat_' . $letter->id . '.pdf');
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
