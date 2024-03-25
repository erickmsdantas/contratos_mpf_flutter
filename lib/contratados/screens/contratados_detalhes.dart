import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratos_mpf/contratados/models/contratado.dart';
import 'package:contratos_mpf/contratados/widgets/item_detalhe_basico.dart';
import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:contratos_mpf/contratos/screens/contrato_detalhes.dart';
import 'package:contratos_mpf/favoritos/models/favoritos.dart';
import 'package:contratos_mpf/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contratos_mpf/service.dart';
import 'package:page_transition/page_transition.dart';

class ContratadoDetalhes extends StatefulWidget {
  ContratadoDetalhes({super.key, required this.contratado});

  Contratado contratado;

  @override
  State<ContratadoDetalhes> createState() => _ContratadoDetalhesState();
}

class _ContratadoDetalhesState extends State<ContratadoDetalhes>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  _titulo() {
    return ItemDetalheBasico(
      titulo: widget.contratado.nome,
      descricao: widget.contratado.cpfCnpj,
    );
  }

  _listarContratos(String situacao) {
    CollectionReference<Contrato> collection =
        FirebaseRepository.instance.contratosCollection;

    var ugs = ApiService().getUnidadesGestoras();

    return FirestoreListView<Contrato>(
      query: collection
          .where('contratado', isEqualTo: widget.contratado.cpfCnpj)
          .where('situacao', isEqualTo: situacao), //.orderBy('cpf_cnpj'),
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
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: ContratoDetalhes(
                  contrato: e,
                ),
              ),
            );
          },
        );
      },
    ) /*)*/;
  }

  _listaContratos() {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          child: TabBar(
            tabs: [
              Container(
                //width: 70.0,
                child: const Text(
                  'Ativos',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                //width: 75.0,
                child: const Text(
                  'Concluídos',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
            unselectedLabelColor: const Color(0xffacb3bf),
            indicatorColor: const Color(0xFF629784),
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3.0,
            indicatorPadding: const EdgeInsets.all(10),
            isScrollable: false,
            controller: _tabController,
          ),
        ),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _listarContratos('ativo'),
              _listarContratos('concluído')
            ],
          ),
        ),
      ],
    );
  }

  _adicionarOuRemoverFavorito(String userId, Favoritos favoritos) {
    if (favoritos.hasContratado(widget.contratado.cpfCnpj)) {
      favoritos.removerContratado(widget.contratado.cpfCnpj);
    } else {
      favoritos.addContratado(widget.contratado.cpfCnpj);
    }

    FirebaseRepository.instance
        .salvarFavoritos(userId, favoritos)
        .then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<Favoritos>(
        future: FirebaseRepository.instance.getFavoritosForUser(user!.uid),
        builder: (BuildContext context, AsyncSnapshot<Favoritos> snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error!}');
          }

          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var favoritos = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('DETALHES DO CONTRATADO'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(favoritos.hasContratado(widget.contratado.cpfCnpj)
                      ? Icons.favorite_outlined
                      : Icons.favorite_outline),
                  onPressed: () {
                    _adicionarOuRemoverFavorito(user.uid, favoritos);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titulo(),
                  _listaContratos(),
                ],
              ),
            ),
          );
        });
  }
}
