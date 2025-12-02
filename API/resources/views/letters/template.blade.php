<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Surat {{ $letter->letterFormat->name ?? 'Pengajuan' }}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            line-height: 1.6;
        }
        .header {
            text-align: center;
            margin-bottom: 40px;
        }
        .content {
            text-align: justify;
        }
        .signature-section {
            margin-top: 60px;
            text-align: right;
        }
        .info-row {
            margin-bottom: 10px;
        }
        .label {
            font-weight: bold;
            display: inline-block;
            width: 120px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h2>SURAT {{ strtoupper($letter->letterFormat->name ?? 'PENGAJUAN') }}</h2>
    </div>

    <div style="text-align: right; margin-bottom: 30px;">
        <p>Malang, {{ \Carbon\Carbon::parse($letter->tanggal)->locale('id')->isoFormat('DD MMMM YYYY') }}</p>
    </div>

    <div style="margin-bottom: 30px;">
        <p><strong>Perihal:</strong> Surat {{ $letter->letterFormat->name ?? 'Pengajuan' }}</p>
    </div>

    <div style="margin-bottom: 30px;">
        <p>Yth. HRD Perusahaan HRIS<br>di tempat</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p>Dengan hormat,</p>
        <p>Saya yang bertanda tangan di bawah ini:</p>
    </div>

    <div style="margin-bottom: 30px;">
        <div class="info-row">
            <span class="label">Nama</span>
            <span>: {{ $letter->name }}</span>
        </div>
        <div class="info-row">
            <span class="label">Jabatan</span>
            <span>: {{ $letter->jabatan }}</span>
        </div>
        <div class="info-row">
            <span class="label">Departemen</span>
            <span>: {{ $letter->departemen }}</span>
        </div>
    </div>

    <div class="content" style="margin-bottom: 30px;">
        <p>{{ $letter->letterFormat->content ?? 'Bermaksud mengajukan surat pengajuan.' }}</p>
    </div>

    <div class="content" style="margin-bottom: 40px;">
        <p>Demikian surat {{ strtolower($letter->letterFormat->name ?? 'pengajuan') }} ini saya ajukan. 
        Atas perhatiannya, saya ucapkan terima kasih.</p>
    </div>

    <div class="signature-section">
        <p>Hormat saya,</p>
        <div style="height: 60px;"></div>
        <p>{{ $letter->name }}</p>
    </div>

    <div style="margin-top: 80px; padding-top: 20px; border-top: 1px solid #ccc; font-size: 10px; text-align: center;">
        <p>Dokumen ini dihasilkan secara otomatis oleh Sistem HRIS</p>
    </div>
</body>
</html>
