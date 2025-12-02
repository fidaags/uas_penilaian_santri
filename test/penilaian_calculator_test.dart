// test/penilaian_calculator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:e_penilaian_santri/core/utils/penilaian_calculator.dart';

void main() {
  test('Konversi akhlak 3.75 -> 94', () {
    final nilai = PenilaianCalculator.hitungAkhlak(
      disiplin: 4,
      adab: 4,
      kebersihan: 3,
      kerjasama: 4,
    );
    expect(nilai, 94);
  });

  test('Rekap kehadiran s1 (18,1,1,0) -> 90', () {
    final nilai = PenilaianCalculator.hitungKehadiran(
      hadir: 18,
      sakit: 1,
      izin: 1,
      alpa: 0,
    );
    expect(nilai, 90);
  });

  test('Nilai akhir s1 sesuai contoh -> 89', () {
    final tahfidz = 93;
    final fiqh = 86;
    final bahasaArab = 78;
    final akhlak = 94;
    final kehadiran = 90;

    final finalNilai = PenilaianCalculator.hitungFinal(
      tahfidz: tahfidz,
      fiqh: fiqh,
      bahasaArab: bahasaArab,
      akhlak: akhlak,
      kehadiran: kehadiran,
      bobotTahfidz: 0.30,
      bobotFiqh: 0.20,
      bobotBahasaArab: 0.20,
      bobotAkhlak: 0.20,
      bobotKehadiran: 0.10,
    );

    expect(finalNilai, 89);
  });

  test('Predikat A/B/C/D sesuai range', () {
    expect(PenilaianCalculator.predikat(90), 'A');
    expect(PenilaianCalculator.predikat(80), 'B');
    expect(PenilaianCalculator.predikat(70), 'C');
    expect(PenilaianCalculator.predikat(60), 'D');
  });
}
