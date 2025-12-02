import 'dart:math';

class PenilaianCalculator {
  static int hitungTahfidz({
    required int ayatSetor,
    required int targetAyat,
    required int tajwid,
  }) {
    final capaian = min(100.0, (ayatSetor / targetAyat) * 100.0);
    final nilai = 0.5 * capaian + 0.5 * tajwid;
    return nilai.round();
  }

  static int hitungMapel({
    required int formatif,
    required int sumatif,
  }) {
    final nilai = 0.4 * formatif + 0.6 * sumatif;
    return nilai.round();
  }

  static int hitungAkhlak({
    required int disiplin,
    required int adab,
    required int kebersihan,
    required int kerjasama,
  }) {
    final avg = (disiplin + adab + kebersihan + kerjasama) / 4.0;
    final nilai = (avg / 4.0) * 100.0;
    return nilai.round();
  }

  static int hitungKehadiran({
    required int hadir,
    required int sakit,
    required int izin,
    required int alpa,
  }) {
    final total = hadir + sakit + izin + alpa;
    if (total == 0) return 0;
    final persen = (hadir / total) * 100.0;
    return persen.round();
  }

  static int hitungFinal({
    required int tahfidz,
    required int fiqh,
    required int bahasaArab,
    required int akhlak,
    required int kehadiran,
    required double bobotTahfidz,
    required double bobotFiqh,
    required double bobotBahasaArab,
    required double bobotAkhlak,
    required double bobotKehadiran,
  }) {
    final nilai = bobotTahfidz * tahfidz +
        bobotFiqh * fiqh +
        bobotBahasaArab * bahasaArab +
        bobotAkhlak * akhlak +
        bobotKehadiran * kehadiran;
    return nilai.round();
  }

  static String predikat(int nilaiAkhir) {
    if (nilaiAkhir >= 85) return 'A';
    if (nilaiAkhir >= 75) return 'B';
    if (nilaiAkhir >= 65) return 'C';
    return 'D';
  }
}
