// lib/features/penilaian/data/penilaian_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import 'penilaian_repository.dart';

final penilaianRepositoryProvider = Provider<PenilaianRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return PenilaianRepository(firestore);
});
