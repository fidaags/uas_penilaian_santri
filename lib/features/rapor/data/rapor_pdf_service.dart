import 'package:flutter/material.dart' show BuildContext;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../santri/domain/santri_model.dart';
import '../../penilaian/data/ringkasan_penilaian.dart';

class RaporPdfService {
  Future<void> cetakRapor({
    required BuildContext context,
    required Santri santri,
    required RingkasanPenilaianSantri ringkasan,
    required int nilaiAkhir,
    required String predikat,
  }) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Rapor Santri', style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 12),
            pw.Text('Nama: ${santri.nama}'),
            pw.Text('NIS: ${santri.nis}'),
            pw.Text('Kamar: ${santri.kamar}'),
            pw.SizedBox(height: 12),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _row('Tahfidz', ringkasan.tahfidz),
                _row('Fiqh', ringkasan.fiqh),
                _row('Bahasa Arab', ringkasan.bahasaArab),
                _row('Akhlak', ringkasan.akhlak),
                _row('Kehadiran', ringkasan.kehadiran),
                _row('Nilai Akhir', nilaiAkhir),
                _row('Predikat', predikat),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Text('Catatan Ustadz:'),
            pw.Text(ringkasan.catatanUstadz ?? '-'),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
    );
  }

  pw.TableRow _row(String label, Object value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(label),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(value.toString()),
        ),
      ],
    );
  }
}
