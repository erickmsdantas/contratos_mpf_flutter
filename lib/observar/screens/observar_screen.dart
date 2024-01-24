import 'package:contratos_mpf/nav_menu.dart';
import 'package:contratos_mpf/observar/models/observacao.dart';
import 'package:contratos_mpf/observar/screens/nova_obsercavao_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ObservarScreen extends StatefulWidget {
  const ObservarScreen({super.key});

  @override
  State<ObservarScreen> createState() => _ObservarScreenState();
}

class _ObservarScreenState extends State<ObservarScreen> {
  late List<Observacao> _observacoes = [Observacao(id: 1), Observacao(id: 2)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavMenu(),
        appBar: AppBar(
          title: const Text("OBSERVAÇÕES"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.plus),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NovaObservacaoScreen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          child: ListView.separated(
            itemCount: _observacoes.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 3),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                tileColor: Colors.white,
                title: Text('#${_observacoes[index].id}'),
                trailing: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.trash),
                  onPressed: () {},
                ),
              );
            },
          ),
      ),
    );
  }
}
