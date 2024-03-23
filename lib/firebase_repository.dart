import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratos_mpf/contratados/models/contratado.dart';
import 'package:contratos_mpf/favoritos/models/favoritos.dart';
import 'package:contratos_mpf/contratos/models/contrato.dart';

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

  final CollectionReference<Contratado> contratadosCollection =
      fireStorage.collection('contratados').withConverter<Contratado>(
            fromFirestore: (snapshots, _) =>
                Contratado.fromJson(snapshots.id, snapshots.data()!),
            toFirestore: (concern, _) => throw "TODO",
          );

  final CollectionReference<Favoritos> favoritosCollection =
      fireStorage.collection('favoritos').withConverter<Favoritos>(
            fromFirestore: (snapshots, _) =>
                Favoritos.fromJson(snapshots.id, snapshots.data()!),
            toFirestore: (concern, _) => throw "TODO",
          );

  Future<void> salvarFavoritos(String userId, Favoritos favoritos) async {
    DocumentReference<Favoritos> favoritosRef = fireStorage
        .collection('favoritos')
        .doc(userId)
        .withConverter<Favoritos>(
          fromFirestore: (snapshots, _) =>
              Favoritos.fromJson(snapshots.id, snapshots.data()!),
          toFirestore: (favoritos, _) => favoritos.toJson(),
        );

    await favoritosRef.set(favoritos);
  }

  Future<Favoritos> getFavoritosForUser(String userId) async {
    DocumentReference<Favoritos> favoritosRef = fireStorage
        .collection('favoritos')
        .doc(userId)
        .withConverter<Favoritos>(
          fromFirestore: (snapshots, _) =>
              Favoritos.fromJson(snapshots.id, snapshots.data()!),
          toFirestore: (concern, _) => throw "TODO",
        );

    var doc = await favoritosRef.get();

    if (!doc.exists) {
      return Favoritos(
          id: userId,
          contratosFavoritos: [],
          contratadosFavoritos: [],
          unidadesFavoritas: []);
    }

    return doc.data()!;
  }
}
