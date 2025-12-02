import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../penilaian/data/penilaian_providers.dart';
import '../../penilaian/data/ringkasan_penilaian.dart';
import '../../santri/data/santri_providers.dart';
import '../../santri/domain/santri_model.dart';
import '../../../core/utils/penilaian_calculator.dart';
import '../data/rapor_pdf_service.dart';

class RaporPage extends ConsumerWidget {
  final String santriId;
  const RaporPage({super.key, required this.santriId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final penilaianRepo = ref.watch(penilaianRepositoryProvider);
    final santriRepo = ref.watch(santriRepositoryProvider);

    return FutureBuilder<List<Object?>>(
      future: Future.wait([
        santriRepo.getById(santriId),
        penilaianRepo.getRingkasanSantri(santriId),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        final santri = data[0] as Santri;
        final ringkasan = data[1] as RingkasanPenilaianSantri;

        final finalNilai = PenilaianCalculator.hitungFinal(
          tahfidz: ringkasan.tahfidz,
          fiqh: ringkasan.fiqh,
          bahasaArab: ringkasan.bahasaArab,
          akhlak: ringkasan.akhlak,
          kehadiran: ringkasan.kehadiran,
          bobotTahfidz: ringkasan.bobot.tahfidz,
          bobotFiqh: ringkasan.bobot.fiqh,
          bobotBahasaArab: ringkasan.bobot.bahasaArab,
          bobotAkhlak: ringkasan.bobot.akhlak,
          bobotKehadiran: ringkasan.bobot.kehadiran,
        );
        final predikat = PenilaianCalculator.predikat(finalNilai);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: ListTile(
                  title: Text(santri.nama),
                  subtitle: Text('${santri.nis} • Kamar ${santri.kamar}'),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _nilaiRow('Tahfidz', ringkasan.tahfidz),
                      _nilaiRow('Fiqh', ringkasan.fiqh),
                      _nilaiRow('Bahasa Arab', ringkasan.bahasaArab),
                      _nilaiRow('Akhlak', ringkasan.akhlak),
                      _nilaiRow('Kehadiran', ringkasan.kehadiran),
                      const Divider(),
                      _nilaiRow('Nilai Akhir', finalNilai,
                          isBold: true, highlight: true),
                      const SizedBox(height: 8),
                      Text(
                        'Predikat: $predikat',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Catatan Ustadz:\n${ringkasan.catatanUstadz ?? '-'}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await RaporPdfService().cetakRapor(
                      context: context,
                      santri: santri,
                      ringkasan: ringkasan,
                      nilaiAkhir: finalNilai,
                      predikat: predikat,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Unduh PDF'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _nilaiRow(String label, int nilai,
      {bool isBold = false, bool highlight = false}) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: highlight ? Colors.indigo : null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(nilai.toString(), style: style),
        ],
      ),
    );
  }
}
