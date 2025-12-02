import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/penilaian_models.dart';
import 'ringkasan_penilaian.dart';
import '../../../core/utils/penilaian_calculator.dart';

class PenilaianRepository {
  final FirebaseFirestore _firestore;

  PenilaianRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _tahfidzCol =>
      _firestore.collection('penilaian_tahfidz');

  CollectionReference<Map<String, dynamic>> get _mapelCol =>
      _firestore.collection('penilaian_mapel');

  CollectionReference<Map<String, dynamic>> get _akhlakCol =>
      _firestore.collection('penilaian_akhlak');

  CollectionReference<Map<String, dynamic>> get _kehadiranCol =>
      _firestore.collection('kehadiran');

  DocumentReference<Map<String, dynamic>> get _configBobotDoc =>
      _firestore.collection('config').doc('bobot');

  String newId() => _tahfidzCol.doc().id;

  Future<void> saveTahfidz(PenilaianTahfidz data) async {
    await _tahfidzCol.doc(data.id).set(data.toJson());
  }

  // ===== RINGKASAN NILAI PER SANTRI =====
  Future<RingkasanPenilaianSantri> getRingkasanSantri(String santriId) async {
    // Tahfidz: ambil entri terakhir
    int nilaiTahfidz = 0;
    final tahfidzSnap = await _tahfidzCol
        .where('santriId', isEqualTo: santriId)
        .orderBy('minggu', descending: true)
        .limit(1)
        .get();
    if (tahfidzSnap.docs.isNotEmpty) {
      final d =
          PenilaianTahfidz.fromJson(tahfidzSnap.docs.first.data(), tahfidzSnap.docs.first.id);
      nilaiTahfidz = PenilaianCalculator.hitungTahfidz(
        ayatSetor: d.ayatSetor,
        targetAyat: 50, // TODO: ambil dari config target jika ada
        tajwid: d.tajwid,
      );
    }

    // Mapel Fiqh
    int nilaiFiqh = 0;
    final fiqhSnap = await _mapelCol
        .where('santriId', isEqualTo: santriId)
        .where('mapel', isEqualTo: 'Fiqh')
        .limit(1)
        .get();
    if (fiqhSnap.docs.isNotEmpty) {
      final d =
          PenilaianMapel.fromJson(fiqhSnap.docs.first.data(), fiqhSnap.docs.first.id);
      nilaiFiqh = PenilaianCalculator.hitungMapel(
          formatif: d.formatif, sumatif: d.sumatif);
    }

    // Mapel Bahasa Arab
    int nilaiBahasaArab = 0;
    final baSnap = await _mapelCol
        .where('santriId', isEqualTo: santriId)
        .where('mapel', isEqualTo: 'Bahasa Arab')
        .limit(1)
        .get();
    if (baSnap.docs.isNotEmpty) {
      final d =
          PenilaianMapel.fromJson(baSnap.docs.first.data(), baSnap.docs.first.id);
      nilaiBahasaArab = PenilaianCalculator.hitungMapel(
          formatif: d.formatif, sumatif: d.sumatif);
    }

    // Akhlak
    int nilaiAkhlak = 0;
    String? catatanUstadz;
    final akhlakSnap = await _akhlakCol
        .where('santriId', isEqualTo: santriId)
        .limit(1)
        .get();
    if (akhlakSnap.docs.isNotEmpty) {
      final d =
          PenilaianAkhlak.fromJson(akhlakSnap.docs.first.data(), akhlakSnap.docs.first.id);
      nilaiAkhlak = PenilaianCalculator.hitungAkhlak(
        disiplin: d.disiplin,
        adab: d.adab,
        kebersihan: d.kebersihan,
        kerjasama: d.kerjasama,
      );
      catatanUstadz = d.catatan;
    }

    // Kehadiran
    int nilaiKehadiran = 0;
    final hadirSnap = await _kehadiranCol
        .where('santriId', isEqualTo: santriId)
        .get();
    if (hadirSnap.docs.isNotEmpty) {
      int h = 0, s = 0, i = 0, a = 0;
      for (final doc in hadirSnap.docs) {
        final k = Kehadiran.fromJson(doc.data(), doc.id);
        switch (k.status) {
          case StatusKehadiran.hadir:
            h++;
            break;
          case StatusKehadiran.sakit:
            s++;
            break;
          case StatusKehadiran.izin:
            i++;
            break;
          case StatusKehadiran.alpa:
            a++;
            break;
        }
      }
      nilaiKehadiran = PenilaianCalculator.hitungKehadiran(
        hadir: h,
        sakit: s,
        izin: i,
        alpa: a,
      );
    }

    // Bobot
    ConfigBobot bobot = const ConfigBobot();
    final configDoc = await _configBobotDoc.get();
    if (configDoc.exists && configDoc.data() != null) {
      bobot = ConfigBobot.fromJson(configDoc.data()!);
    }

    return RingkasanPenilaianSantri(
      tahfidz: nilaiTahfidz,
      fiqh: nilaiFiqh,
      bahasaArab: nilaiBahasaArab,
      akhlak: nilaiAkhlak,
      kehadiran: nilaiKehadiran,
      catatanUstadz: catatanUstadz,
      bobot: bobot,
    );
  }
}
