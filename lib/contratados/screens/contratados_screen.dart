import 'package:contratos_mpf/contratados/models/contratado.dart';
import 'package:contratos_mpf/contratados/screens/contratados_filtro.dart';
import 'package:contratos_mpf/contratados/widgets/campo_busca.dart';
import 'package:contratos_mpf/contratados/widgets/contratados_lista.dart';
import 'package:contratos_mpf/nav_menu.dart';
import 'package:contratos_mpf/service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ContratadosScreen extends StatefulWidget {
  const ContratadosScreen({super.key});

  @override
  State<ContratadosScreen> createState() => _ContratadosScreenState();
}

class _ContratadosScreenState extends State<ContratadosScreen> {
  late List<Contratado> _contratados = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _contratados = (await ApiService().getContratados())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavMenu(),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const ContratadosFiltroScreen(),
            ),
          );
        },
        child: const Icon(Icons.filter_list),
      ),
      appBar: AppBar(
        title: const Text("CONTRATADOS"),
        centerTitle: true,
      ),
      body: ContratadosLista(contratados: _contratados),
    );
  }
}
