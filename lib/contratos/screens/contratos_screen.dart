import 'package:contratos_mpf/contratos/screens/contratos_filtro_screen.dart';
import 'package:contratos_mpf/contratos/widgets/contratos_lista.dart';
import 'package:contratos_mpf/contratos/widgets/contratos_tabela.dart';
import 'package:contratos_mpf/nav_menu.dart';
import 'package:contratos_mpf/utils/filtro_contratos.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

enum ModoExibicao { lista, tabela }

class ContratosScreen extends StatefulWidget {
  const ContratosScreen({super.key});

  @override
  State<ContratosScreen> createState() => _ContratosScreenState();
}

class _ContratosScreenState extends State<ContratosScreen> {
  ModoExibicao? _modoExibicao = ModoExibicao.lista;

  FiltroContratos filtroContratos = FiltroContratos();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        drawer: NavMenu(),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: ContratosFiltroScreen(filtroContratos: filtroContratos,),
              ),
            );

            setState(() {
              filtroContratos = result;
            });
          },
          child: const Icon(Icons.filter_list),
        ),
        appBar:
            AppBar(title: const Text("CONTRATOS"), centerTitle: true, actions: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  if (_modoExibicao == ModoExibicao.lista) {
                    _modoExibicao = ModoExibicao.tabela;
                  } else {
                    _modoExibicao = ModoExibicao.lista;
                  }
                },
              );
            },
            icon: FaIcon(_modoExibicao == ModoExibicao.lista
                ? FontAwesomeIcons.table
                : FontAwesomeIcons.list),
          ),
        ]),
        body: Container(
            child: _modoExibicao == ModoExibicao.lista
                ? ContratosModoLista(filtroContratos: filtroContratos)
                : ContratosModoTabela()),
      ),
    );
  }
}
