// lib/features/penilaian/presentation/tahfidz_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/penilaian_models.dart';
import '../data/penilaian_providers.dart'; // ⬅️ ganti ke provider

class TahfidzFormPage extends ConsumerStatefulWidget {
  final String santriId;
  final int targetAyat; // bisa diambil dari config per minggu

  const TahfidzFormPage({
    super.key,
    required this.santriId,
    required this.targetAyat,
  });

  @override
  ConsumerState<TahfidzFormPage> createState() => _TahfidzFormPageState();
}

class _TahfidzFormPageState extends ConsumerState<TahfidzFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _surahC = TextEditingController();
  final _ayatSetorC = TextEditingController();
  final _tajwidC = TextEditingController();
  DateTime _minggu = DateTime.now();

  @override
  void dispose() {
    _surahC.dispose();
    _ayatSetorC.dispose();
    _tajwidC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(penilaianRepositoryProvider);
    final id = repo.newId(); // misal generate docId baru

    final data = PenilaianTahfidz(
      id: id,
      santriId: widget.santriId,
      minggu: _minggu,
      surah: _surahC.text.trim(),
      ayatSetor: int.parse(_ayatSetorC.text),
      tajwid: int.parse(_tajwidC.text),
    );

    await repo.saveTahfidz(data);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Tahfidz')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _surahC,
                decoration: const InputDecoration(
                  labelText: 'Surah',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ayatSetorC,
                decoration: const InputDecoration(
                  labelText: 'Ayat Setor (minggu ini)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) return 'Harus angka > 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tajwidC,
                decoration: const InputDecoration(
                  labelText: 'Nilai Tajwid (0-100)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  final n = int.tryParse(v);
                  if (n == null || n < 0 || n > 100) {
                    return 'Harus 0–100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
