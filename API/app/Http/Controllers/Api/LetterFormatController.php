<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\LetterFormat;
use Illuminate\Http\Request;

class LetterFormatController extends Controller
{
    // GET all templates
    public function index()
    {
        $data = LetterFormat::all();

        return response()->json([
            'success' => true,
            'data' => $data
        ]);
    }

    // GET single template
    public function show($id)
    {
        $data = LetterFormat::find($id);

        if (!$data) {
            return response()->json([
                'success' => false,
                'message' => 'Template tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $data
        ]);
    }

    // POST create new template
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        $data = LetterFormat::create([
            'name' => $request->input('name'),
            'content' => $request->input('content'),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Template berhasil dibuat',
            'data' => $data
        ], 201);
    }

    // PUT update template
    public function update(Request $request, $id)
    {
        $data = LetterFormat::find($id);

        if (!$data) {
            return response()->json([
                'success' => false,
                'message' => 'Template tidak ditemukan'
            ], 404);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        $data->update([
            'name' => $request->input('name'),
            'content' => $request->input('content'),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Template berhasil diupdate',
            'data' => $data
        ]);
    }

    // DELETE template
    public function destroy($id)
    {
        $data = LetterFormat::find($id);

        if (!$data) {
            return response()->json([
                'success' => false,
                'message' => 'Template tidak ditemukan'
            ], 404);
        }

        $data->delete();

        return response()->json([
            'success' => true,
            'message' => 'Template berhasil dihapus'
        ]);
    }
}