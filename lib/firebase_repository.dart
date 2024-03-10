import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:flutter/cupertino.dart';

class FirebaseRepository {
  FirebaseRepository._firebaseRepository();
  static final FirebaseRepository _instance =
  FirebaseRepository._firebaseRepository();

  static FirebaseRepository get instance => _instance;

  static final FirebaseFirestore fireStorage = FirebaseFirestore.instance;

  final CollectionReference<Contrato> contratosCollection =
  fireStorage.collection('contratos').withConverter<Contrato>(
    fromFirestore: (snapshots, _) =>
        Contrato.fromJson(snapshots.id, snapshots.data()!),
    toFirestore: (concern, _) => throw "TODO",
  );
}