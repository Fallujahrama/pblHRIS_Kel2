import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class HrdDetailPage extends StatelessWidget {
  final Map<String, dynamic> surat;

  const HrdDetailPage({super.key, required this.surat});

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> updateStatus(BuildContext context, String status) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(status == 'approved' ? 'Approve Surat?' : 'Reject Surat?'),
        content: Text(
          status == 'approved'
              ? 'Apakah Anda yakin ingin menyetujui surat ini?'
              : 'Apakah Anda yakin ingin menolak surat ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: status == 'approved' ? Colors.green : Colors.red,
            ),
            child: Text(status == 'approved' ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final result = await ApiService.updateStatus(surat['id'], status);
      final success = result['success'] as bool? ?? false;

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                status == 'approved'
                    ? 'Surat berhasil disetujui dan PDF telah dibuat'
                    : 'Surat berhasil ditolak',
              ),
            ),
          );
          context.pop(true); // Kembali ke list dan refresh
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal update status: ${result['body']}'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }

  Future<void> downloadPdf(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengunduh PDF...')),
      );

      final pdfBytes = await ApiService.downloadPdf(surat['id']);

      if (pdfBytes != null && context.mounted) {
        // PDF berhasil diunduh
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'PDF berhasil diunduh: surat_${surat['id']}.pdf',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        print('PDF downloaded: ${pdfBytes.length} bytes');
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengunduh PDF')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = surat['status'] ?? 'pending';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Surat"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Pengajuan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow('Nama', surat['name'] ?? '-'),
                    _buildInfoRow('Jabatan', surat['jabatan'] ?? '-'),
                    _buildInfoRow('Departemen', surat['departemen'] ?? '-'),
                    _buildInfoRow('Jenis Surat', surat['letter_format']?['name'] ?? '-'),
                    _buildInfoRow('Tanggal', formatDate(surat['tanggal'])),
                    _buildInfoRow('Status', status.toUpperCase()),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (status == 'pending') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => updateStatus(context, 'approved'),
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => updateStatus(context, 'rejected'),
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: status == 'approved' ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: status == 'approved' ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Text(
                      'Surat sudah ${status == 'approved' ? 'disetujui' : 'ditolak'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: status == 'approved' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (status == 'approved')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => downloadPdf(context),
                          icon: const Icon(Icons.download),
                          label: const Text('Download PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
