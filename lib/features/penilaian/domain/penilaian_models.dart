// lib/features/penilaian/domain/penilaian_models.dart
import 'package:cloud_firestore/cloud_firestore.dart';


enum StatusKehadiran { hadir, sakit, izin, alpa }

StatusKehadiran statusKehadiranFromString(String value) {
  switch (value) {
    case 'H':
      return StatusKehadiran.hadir;
    case 'S':
      return StatusKehadiran.sakit;
    case 'I':
      return StatusKehadiran.izin;
    case 'A':
    default:
      return StatusKehadiran.alpa;
  }
}

String statusKehadiranToCode(StatusKehadiran status) {
  switch (status) {
    case StatusKehadiran.hadir:
      return 'H';
    case StatusKehadiran.sakit:
      return 'S';
    case StatusKehadiran.izin:
      return 'I';
    case StatusKehadiran.alpa:
      return 'A';
  }
}

class PenilaianTahfidz {
  final String id;
  final String santriId;
  final DateTime minggu;
  final String surah;
  final int ayatSetor;
  final int tajwid;

  PenilaianTahfidz({
    required this.id,
    required this.santriId,
    required this.minggu,
    required this.surah,
    required this.ayatSetor,
    required this.tajwid,
  });

  factory PenilaianTahfidz.fromJson(Map<String, dynamic> json, String id) {
    return PenilaianTahfidz(
      id: id,
      santriId: json['santriId'] as String,
      minggu: (json['minggu'] as Timestamp).toDate(),
      surah: json['surah'] as String,
      ayatSetor: json['ayat_setor'] as int,
      tajwid: json['tajwid_0_100'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'santriId': santriId,
      'minggu': minggu,
      'surah': surah,
      'ayat_setor': ayatSetor,
      'tajwid_0_100': tajwid,
    };
  }
}

class PenilaianMapel {
  final String id;
  final String santriId;
  final String mapel; // "Fiqh" | "Bahasa Arab"
  final int formatif;
  final int sumatif;

  PenilaianMapel({
    required this.id,
    required this.santriId,
    required this.mapel,
    required this.formatif,
    required this.sumatif,
  });

  factory PenilaianMapel.fromJson(Map<String, dynamic> json, String id) {
    return PenilaianMapel(
      id: id,
      santriId: json['santriId'] as String,
      mapel: json['mapel'] as String,
      formatif: json['formatif_0_100'] as int,
      sumatif: json['sumatif_0_100'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'santriId': santriId,
      'mapel': mapel,
      'formatif_0_100': formatif,
      'sumatif_0_100': sumatif,
    };
  }
}

class PenilaianAkhlak {
  final String id;
  final String santriId;
  final int disiplin;
  final int adab;
  final int kebersihan;
  final int kerjasama;
  final String catatan;

  PenilaianAkhlak({
    required this.id,
    required this.santriId,
    required this.disiplin,
    required this.adab,
    required this.kebersihan,
    required this.kerjasama,
    required this.catatan,
  });

  factory PenilaianAkhlak.fromJson(Map<String, dynamic> json, String id) {
    return PenilaianAkhlak(
      id: id,
      santriId: json['santriId'] as String,
      disiplin: json['disiplin_1_4'] as int,
      adab: json['adab_1_4'] as int,
      kebersihan: json['kebersihan_1_4'] as int,
      kerjasama: json['kerjasama_1_4'] as int,
      catatan: json['catatan'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'santriId': santriId,
      'disiplin_1_4': disiplin,
      'adab_1_4': adab,
      'kebersihan_1_4': kebersihan,
      'kerjasama_1_4': kerjasama,
      'catatan': catatan,
    };
  }
}

class Kehadiran {
  final String id;
  final String santriId;
  final DateTime tanggal;
  final StatusKehadiran status;

  Kehadiran({
    required this.id,
    required this.santriId,
    required this.tanggal,
    required this.status,
  });

  factory Kehadiran.fromJson(Map<String, dynamic> json, String id) {
    return Kehadiran(
      id: id,
      santriId: json['santriId'] as String,
      tanggal: (json['tanggal'] as Timestamp).toDate(),
      status: statusKehadiranFromString(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'santriId': santriId,
      'tanggal': tanggal,
      'status': statusKehadiranToCode(status),
    };
  }
}

class ConfigBobot {
  final double tahfidz;
  final double fiqh;
  final double bahasaArab;
  final double akhlak;
  final double kehadiran;

  const ConfigBobot({
    this.tahfidz = 0.30,
    this.fiqh = 0.20,
    this.bahasaArab = 0.20,
    this.akhlak = 0.20,
    this.kehadiran = 0.10,
  });

  factory ConfigBobot.fromJson(Map<String, dynamic> json) {
    return ConfigBobot(
      tahfidz: (json['tahfidz'] as num).toDouble(),
      fiqh: (json['fiqh'] as num).toDouble(),
      bahasaArab: (json['bahasaArab'] as num).toDouble(),
      akhlak: (json['akhlak'] as num).toDouble(),
      kehadiran: (json['kehadiran'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tahfidz': tahfidz,
      'fiqh': fiqh,
      'bahasaArab': bahasaArab,
      'akhlak': akhlak,
      'kehadiran': kehadiran,
    };
  }
}
