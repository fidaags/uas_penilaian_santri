// lib/features/penilaian/data/ringkasan_penilaian.dart

import '../domain/penilaian_models.dart';  // sudah ada ConfigBobot

class RingkasanPenilaianSantri {
  final int tahfidz;
  final int fiqh;
  final int bahasaArab;
  final int akhlak;
  final int kehadiran;
  final String? catatanUstadz;
  final ConfigBobot bobot;

  const RingkasanPenilaianSantri({
    required this.tahfidz,
    required this.fiqh,
    required this.bahasaArab,
    required this.akhlak,
    required this.kehadiran,
    this.catatanUstadz,
    required this.bobot,
  });
}
