import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> addTransaction(String userId, Map<String, dynamic> data) async {
    await _db.child("transactions/$userId").push().set(data);
  }

  Query getTransactions(String userId) {
    return _db.child("transactions/$userId");
  }
}
