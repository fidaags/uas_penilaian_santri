// lib/features/santri/domain/santri_model.dart
class Santri {
  final String id;
  final String nis;
  final String nama;
  final String kamar;
  final int angkatan;

  Santri({
    required this.id,
    required this.nis,
    required this.nama,
    required this.kamar,
    required this.angkatan,
  });

  factory Santri.fromJson(Map<String, dynamic> json, String id) {
    return Santri(
      id: id,
      nis: json['nis'] as String,
      nama: json['nama'] as String,
      kamar: json['kamar'] as String,
      angkatan: json['angkatan'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama': nama,
      'kamar': kamar,
      'angkatan': angkatan,
    };
  }
}
