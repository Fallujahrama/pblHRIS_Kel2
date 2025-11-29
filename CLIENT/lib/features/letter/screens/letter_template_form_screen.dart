import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/letter_format.dart';
import '../controllers/letter_controller.dart';

class LetterTemplateFormScreen extends StatefulWidget {
  final LetterFormat? template; // null = create, ada value = edit

  const LetterTemplateFormScreen({super.key, this.template});

  @override
  State<LetterTemplateFormScreen> createState() => _LetterTemplateFormScreenState();
}

class _LetterTemplateFormScreenState extends State<LetterTemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contentController = TextEditingController();
  final controller = LetterController();

  bool isEdit = false;

  // Template default
  static const String defaultTemplate = """SURAT [JENIS SURAT]

Kepada Yth,
HRD / Atasan Langsung

Dengan ini saya, {{nama}}, mengajukan permohonan [keterangan] 
pada tanggal {{tanggal}}.

Jabatan: {{jabatan}}
Departemen: {{departemen}}

Demikian permohonan ini saya sampaikan. 
Atas pengertian dan kebijaksanaannya saya ucapkan terima kasih.

Hormat saya,
{{nama}}""";

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      isEdit = true;
      nameController.text = widget.template!.name;
      contentController.text = widget.template!.content;
    } else {
      // Set default template untuk create baru
      contentController.text = defaultTemplate;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': nameController.text,
      'content': contentController.text,
    };

    try {
      if (isEdit) {
        await controller.updateLetterFormat(widget.template!.id, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Template berhasil diupdate')),
          );
        }
      } else {
        await controller.createLetterFormat(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Template berhasil dibuat')),
          );
        }
      }
      
      if (mounted) {
        context.pop(true); // Return true untuk reload list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _resetToDefault() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset ke Template Default'),
        content: const Text('Apakah Anda yakin ingin mereset ke template default? Perubahan akan hilang.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                contentController.text = defaultTemplate;
              });
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Template' : 'Buat Template Baru'),
        actions: [
          if (!isEdit)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset ke Default',
              onPressed: _resetToDefault,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Template',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Template',
                        hintText: 'Contoh: Surat Cuti Tahunan',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama template harus diisi';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        labelText: 'Isi Template',
                        hintText: 'Edit template surat di sini...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 15,
                      style: const TextStyle(fontFamily: 'monospace'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi template harus diisi';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline, size: 20, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Placeholder yang tersedia:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('• {{nama}} - Nama karyawan'),
                          const Text('• {{jabatan}} - Jabatan karyawan'),
                          const Text('• {{departemen}} - Departemen'),
                          const Text('• {{tanggal}} - Tanggal pengajuan'),
                          const SizedBox(height: 8),
                          Text(
                            'Placeholder akan diganti otomatis saat surat dibuat.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? 'Update Template' : 'Simpan Template'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    contentController.dispose();
    super.dispose();
  }
}