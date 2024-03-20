import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratos_mpf/contratados/models/contratado.dart';
import 'package:contratos_mpf/contratados/screens/contratados_detalhes.dart';
import 'package:contratos_mpf/contratos/screens/contrato_detalhes.dart';
import 'package:contratos_mpf/favoritos/models/favoritos.dart';
import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:contratos_mpf/firebase_repository.dart';
import 'package:contratos_mpf/nav_menu.dart';
import 'package:contratos_mpf/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  _listaContratosFavoritos(List<String> contratos) {
    CollectionReference<Contrato> collection =
        FirebaseRepository.instance.contratosCollection;

    if (contratos.isEmpty) {
      return const Text('Sem Favoritos');
    }

    var ugs = ApiService().getUnidadesGestoras();

    return FirestoreListView<Contrato>(
      query: collection.where('nr_contrato',
          whereIn: contratos), //.orderBy('cpf_cnpj'),
      itemBuilder: (context, snapshot) {
        Contrato e = snapshot.data();
        return ListTile(
          title: Text(e.numero),
          subtitle: Text(ugs[e.unidade] ?? ''),
          trailing: Text(
            '${e.inicioVigencia.day.toString().padLeft(2, '0')}/${e.inicioVigencia.month.toString().padLeft(2, '0')}/${e.inicioVigencia.year}' +
                ' - ' +
                '${e.terminoVigencia.day.toString().padLeft(2, '0')}/${e.terminoVigencia.month.toString().padLeft(2, '0')}/${e.terminoVigencia.year}',
          ),
          tileColor: Colors.white,
          onTap: () async {
            await Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: ContratoDetalhes(
                  contrato: e,
                ),
              ),
            );

            setState(() {});
          },
        );
      },
    ) /*)*/;
  }

  _listaContratadosFavoritos(List<String> contratados) {
    CollectionReference<Contratado> collection =
        FirebaseRepository.instance.contratadosCollection;

    if (contratados.isEmpty) {
      return const Text('Sem Favoritos');
    }

    var ugs = ApiService().getUnidadesGestoras();

    return FirestoreListView<Contratado>(
      query: collection.where('cpf_cnpj',
          whereIn: contratados), //.orderBy('cpf_cnpj'),
      itemBuilder: (context, snapshot) {
        Contratado e = snapshot.data();
        return ListTile(
          title: Text(e.cpfCnpj),
          subtitle: Text(e.nome),
          tileColor: Colors.white,
          onTap: () async {
            await Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: ContratadoDetalhes(
                  contratado: e,
                ),
              ),
            );

            setState(() {});
          },
        );
      },
    ) /*)*/;
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
                text: 'Unidades',
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
                _listaContratadosFavoritos(snapshot.data!.contratadosFavoritos),
                _listaContratosFavoritos(snapshot.data!.unidadesFavoritas),
              ],
            );
          },
        ),
      ),
    );
  }
}
