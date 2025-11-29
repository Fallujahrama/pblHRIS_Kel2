import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';


class HrdDetailPage extends StatefulWidget {
  final Map<String, dynamic> surat;
  const HrdDetailPage({required this.surat, super.key});

  @override
  State<HrdDetailPage> createState() => _HrdDetailPageState();
}

class _HrdDetailPageState extends State<HrdDetailPage> {
  bool loading = false;

  Future<void> updateStatus(String status) async {
    setState(() => loading = true);
    final ok = await ApiService.updateStatus(widget.surat['id'], status);
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? "Status diubah" : "Gagal ubah status")),
    );

    if (ok) {
      context.pop(); // kembali ke list (list akan reload karena kita await sebelumnya)
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.surat;
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Surat")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama : ${s['nama'] ?? '-'}"),
            Text("Jenis Surat : ${s['jenis_surat'] ?? '-'}"),
            Text("Tanggal : ${s['tanggal'] ?? '-'}"),
            Text("Status : ${s['status'] ?? '-'}"),
            const SizedBox(height: 30),
            loading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => updateStatus("approved"),
                        child: const Text("Approve"),
                      ),
                      ElevatedButton(
                        onPressed: () => updateStatus("rejected"),
                        child: const Text("Reject"),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
