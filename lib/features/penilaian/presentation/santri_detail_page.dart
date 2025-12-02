// lib/features/penilaian/presentation/santri_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import '../../santri/data/santri_repository.dart';
import '../../santri/data/santri_providers.dart';

import '../../santri/domain/santri_model.dart';
import '../../rapor/presentation/rapor_page.dart';
// TODO: import form pages & grafik Tahfidz

class SantriDetailPage extends ConsumerWidget {
  final String santriId;
  const SantriDetailPage({super.key, required this.santriId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(santriRepositoryProvider);

    return FutureBuilder<Santri?>(
      future: repo.getById(santriId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final santri = snapshot.data!;
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text(santri.nama),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Penilaian'),
                  Tab(text: 'Kehadiran'),
                  Tab(text: 'Grafik Tahfidz'),
                  Tab(text: 'Rapor'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _PenilaianTab(santriId: santri.id),
                _KehadiranTab(santriId: santri.id),
                _GrafikTahfidzTab(santriId: santri.id),
                RaporPage(santriId: santri.id),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PenilaianTab extends StatelessWidget {
  final String santriId;
  const _PenilaianTab({required this.santriId});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ListTile(
          title: const Text('Tahfidz'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // buka form tahfidz
          },
        ),
        ListTile(
          title: const Text('Fiqh'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // buka form mapel fiqh
          },
        ),
        ListTile(
          title: const Text('Bahasa Arab'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // buka form mapel Bahasa Arab
          },
        ),
        ListTile(
          title: const Text('Akhlak'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // buka form akhlak
          },
        ),
      ],
    );
  }
}

class _KehadiranTab extends StatelessWidget {
  final String santriId;
  const _KehadiranTab({required this.santriId});

  @override
  Widget build(BuildContext context) {
    // TODO: tampilkan list kehadiran + tombol tambah
    return const Center(child: Text('Kehadiran - TODO'));
  }
}

class _GrafikTahfidzTab extends StatelessWidget {
  final String santriId;
  const _GrafikTahfidzTab({required this.santriId});

  @override
  Widget build(BuildContext context) {
    // TODO: gunakan fl_chart untuk bar/line chart perkembangan mingguan
    return const Center(child: Text('Grafik Tahfidz - TODO'));
  }
}
