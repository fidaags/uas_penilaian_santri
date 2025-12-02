// lib/features/santri/data/santri_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/santri_model.dart';

class SantriRepository {
  final FirebaseFirestore _firestore;

  SantriRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('santri');

  Stream<List<Santri>> watchAll() {
    return _col.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Santri.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  Future<Santri?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return Santri.fromJson(doc.data()!, doc.id);
  }

  Future<void> create(Santri santri) async {
    await _col.doc(santri.id).set(santri.toJson());
  }

  Future<void> update(Santri santri) async {
    await _col.doc(santri.id).update(santri.toJson());
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
