import 'package:contratos_mpf/widgets/filtro_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Situacao { algum_ativo, apenas_concluidos, ativos_ou_concluidos }

class ContratadosFiltroScreen extends StatefulWidget {
  const ContratadosFiltroScreen({super.key, required this.situacao});

  final Situacao situacao;

  @override
  State<ContratadosFiltroScreen> createState() =>
      _ContratadosFiltroScreenState();
}

class _ContratadosFiltroScreenState extends State<ContratadosFiltroScreen> {
  Situacao _situacao = Situacao.ativos_ou_concluidos;

  @override
  void initState() {
    _situacao = widget.situacao;
    super.initState();
  }

  _situacaoFiltro() {
    return FiltroItem(
      titulo: "Situação",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListTile(
            title: const Text('Ativos ou Concluidos'),
            leading: Radio<Situacao>(
              groupValue: _situacao,
              value: Situacao.ativos_ou_concluidos,
              onChanged: (Situacao? value) {
                setState(() {
                  _situacao = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Algum Ativo'),
            leading: Radio<Situacao>(
              groupValue: _situacao,
              value: Situacao.algum_ativo,
              onChanged: (Situacao? value) {
                setState(() {
                  _situacao = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Apenas Concluidos'),
            leading: Radio<Situacao>(
              groupValue: _situacao,
              value: Situacao.apenas_concluidos,
              onChanged: (Situacao? value) {
                setState(() {
                  _situacao = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FILTRAR CONTRATADOS"),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Restaurar"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, _situacao);
                    },
                    child: const Text("Aplicar"),
                  ),
                ],
              ),
            ),
            _situacaoFiltro(),
          ],
        ),
      ),
    );
  }
}
