import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratos_mpf/favoritos/models/favorito.dart';
import 'package:contratos_mpf/favoritos/models/favoritos.dart';
import 'package:contratos_mpf/firebase_repository.dart';
import 'package:contratos_mpf/nav_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  late List<Favorito> _observacoes = [Favorito(id: 1), Favorito(id: 2)];

  _listaContratosFavoritos(List<String> contratos) {
    return ListView.builder(
      itemCount: contratos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(contratos[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Contratos',
              ),
              Tab(
                text: 'Contratados',
              ),
              Tab(
                text: 'Unidades Gestoras',
              ),
            ],
          ),
          title: const Text('FAVORITOS'),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: FirebaseRepository.instance.getFavoritosForUser(user!.uid),
            builder: (BuildContext context, AsyncSnapshot<Favoritos> snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              return TabBarView(
                children: [
                  _listaContratosFavoritos(snapshot.data!.contratosFavoritos),
                  Icon(Icons.directions_transit),
                  Icon(Icons.directions_bike),
                ],
              );
            },),
      ),
    );
  }
}
