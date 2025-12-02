// lib/features/santri/presentation/santri_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/santri_providers.dart';
import '../../auth/data/auth_providers.dart';

class SantriListPage extends ConsumerStatefulWidget {
  const SantriListPage({super.key});

  @override
  ConsumerState<SantriListPage> createState() => _SantriListPageState();
}

class _SantriListPageState extends ConsumerState<SantriListPage> {
  String _search = '';
  String _filterKamar = '';
  int? _filterAngkatan;

  @override
  Widget build(BuildContext context) {
    final santriAsync = ref.watch(santriListStreamProvider);
    final appUserAsync = ref.watch(appUserStreamProvider);

    final role = appUserAsync.value?.role ?? 'wali';
    final isAdminOrUstadz = role == 'admin' || role == 'ustadz';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Santri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      floatingActionButton: isAdminOrUstadz
          ? FloatingActionButton(
              onPressed: () {
                // TODO: buka form tambah santri
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari santri...',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: santriAsync.when(
              data: (santriList) {
                final filtered = santriList.where((s) {
                  final bySearch = s.nama.toLowerCase().contains(_search) ||
                      s.nis.toLowerCase().contains(_search);
                  final byKamar = _filterKamar.isEmpty ||
                      s.kamar.toLowerCase() == _filterKamar.toLowerCase();
                  final byAngkatan = _filterAngkatan == null ||
                      s.angkatan == _filterAngkatan;
                  return bySearch && byKamar && byAngkatan;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Belum ada data santri.'));
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final s = filtered[index];

                    // Untuk status sinkron, idealnya ambil dari snapshot metadata.
                    // Di sini kita tampilkan icon default; kamu bisa extend repo
                    // untuk expose info pendingWrites.
                    const isSynced = true;

                    return ListTile(
                      title: Text(s.nama),
                      subtitle: Text('${s.nis} • Kamar ${s.kamar}'),
                      trailing: Icon(
                        isSynced ? Icons.cloud_done : Icons.cloud_upload,
                        color: isSynced ? Colors.green : Colors.orange,
                      ),
                      onTap: () {
                        context.push('/santri/${s.id}');
                      },
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, st) =>
                  Center(child: Text('Error: ${e.toString()}')),
            ),
          ),
        ],
      ),
    );
  }
}
