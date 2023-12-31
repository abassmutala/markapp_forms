import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:markapp_forms/src/constans/api_paths.dart';
import 'package:markapp_forms/src/models/user.dart';

// abstract class Database {
//   Future<List<User>> getAllUsers();
// }

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<T>> _collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference =
        _db.collection(path).orderBy("dateJoined", descending: true);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (document) => builder(document.data()),
          )
          .toList(),
    );
  }

  Future<void> _deleteDoc({
    required String documentPath,
  }) async {
    try {
      final reference = _db.doc(documentPath);
      await reference.delete();
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.toString(),
      );
    }
  }

  Future<String> addUser(User user) async {
    try {
      final CollectionReference collectionReference =
          _db.collection(APIPaths.allUsers());
      final docRef = await collectionReference.add(user.toMap());
      final res = docRef.id;
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUID(String uid) async {
    try {
      final CollectionReference collectionReference =
          _db.collection(APIPaths.allUsers());
      await collectionReference.doc(uid).update({"uid": uid});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      final CollectionReference collectionReference =
          _db.collection(APIPaths.allUsers());
      await collectionReference.doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> setData(Map<String, dynamic> data) async {
  //   try {
  //     final req = await collectionReference.doc(data)
  //   } catch (e) {

  //   }
  // }

  // @override
  // Future<List<User>> getAllUsers() async {
  //   try {
  //     final collection = _db.collection(APIPaths.allUsers);
  //     final req = await collection
  //         .orderBy("dateJoined", descending: true)
  //         .get()
  //         .then((data) => data.docs);
  //     final res = req.map((e) => User.fromMap(e.data())).toList();
  //     return res;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Stream<List<User>> getAllUsers() {
    return _collectionStream(
      path: APIPaths.allUsers(),
      builder: ((data) => User.fromMap(data)),
    );
  }

  Future<User> getUser(String uid) async {
    try {
      final collection = _db.collection(APIPaths.allUsers());
      final docSnapshot = await collection.doc(uid).get();
      final Map<String, dynamic>? data = docSnapshot.data();
      return User.fromMap(data!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    await _deleteDoc(
      documentPath: APIPaths.userProfile(uid),
    );
  }
}
