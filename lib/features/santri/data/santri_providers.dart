// lib/features/santri/data/santri_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import '../../../core/firebase_providers.dart';
import 'santri_repository.dart';
import '../domain/santri_model.dart';

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final santriRepositoryProvider = Provider<SantriRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return SantriRepository(firestore);
});

final santriListStreamProvider = StreamProvider<List<Santri>>((ref) {
  final repo = ref.watch(santriRepositoryProvider);
  return repo.watchAll();
});
