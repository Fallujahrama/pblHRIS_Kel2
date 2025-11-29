import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/letter_controller.dart';
import '../models/letter_format.dart';

class LettersListScreen extends StatefulWidget {
  const LettersListScreen({super.key});

  @override
  State<LettersListScreen> createState() => _LettersListScreenState();
}

class _LettersListScreenState extends State<LettersListScreen> {
  final controller = LetterController();
  List<LetterFormat> formats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() => isLoading = true);
    formats = await controller.fetchLetterFormats();
    setState(() => isLoading = false);
    print('Loaded ${formats.length} formats');
  }

  void _showTemplateDetail(LetterFormat format) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(format.name),
        content: SingleChildScrollView(
          child: Text(format.content),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Tutup'),
          ),
          TextButton.icon(
            onPressed: () {
              context.pop();
              context.push('/letter/template/edit', extra: format);
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _deleteTemplate(LetterFormat format) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Template'),
        content: Text('Apakah Anda yakin ingin menghapus template "${format.name}"?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await controller.deleteLetterFormat(format.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Template "${format.name}" berhasil dihapus')),
          );
          loadData(); // Reload list
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text("Kelola Template Surat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : formats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.description_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text("Belum ada template surat"),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/letter/template/create'),
                        icon: const Icon(Icons.add),
                        label: const Text('Buat Template Baru'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: formats.length,
                  itemBuilder: (_, i) {
                    final item = formats[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            item.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          item.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 20, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Hapus', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              context.push('/letter/template/edit', extra: item);
                            } else if (value == 'delete') {
                              _deleteTemplate(item);
                            }
                          },
                        ),
                        onTap: () => _showTemplateDetail(item),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push('/letter/template/create');
          if (result == true) loadData(); // Reload jika sukses
        },
        icon: const Icon(Icons.add),
        label: const Text('Buat Template'),
      ),
    );
  }
}
