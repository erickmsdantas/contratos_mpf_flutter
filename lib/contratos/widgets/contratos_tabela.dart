import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:contratos_mpf/contratos/widgets/campo_busca.dart';
import 'package:contratos_mpf/firebase_repository.dart';
import 'package:contratos_mpf/service.dart';
import 'package:contratos_mpf/contratos/screens/contrato_detalhes.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class ContratosModoTabela extends StatefulWidget {
  ContratosModoTabela({super.key});

  @override
  State<ContratosModoTabela> createState() => _ContratosModoTabelaState();
}

class _ContratosModoTabelaState extends State<ContratosModoTabela> {
  TextEditingController controller = TextEditingController();

  String _qtdContratos = '';

  @override
  void initState() {
    super.initState();
  }

  Widget criarTabela() {
    CollectionReference<Contrato> collection =
        FirebaseRepository.instance.contratosCollection;

    Query<Contrato> query1 = collection.limit(100); //_buildQuery(collection);

    query1.count().get().then((value) {
      setState(() {
        _qtdContratos = '${value.count}';
      });
    });

    var ugs = ApiService().getUnidadesGestoras();

    return FirestoreQueryBuilder<Contrato>(
      query: query1,
      pageSize: 5,
      builder: (context, snapshot, _) {
        final data = snapshot.docs;

        return DataTable(
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
          dataRowMaxHeight: double.infinity,
          dataRowMinHeight: 50,
          columns: const [
            DataColumn(label: Text("UG")),
            DataColumn(label: Text("Nº do Contrato")),
            DataColumn(label: Text("Objeto")),
            DataColumn(label: Text("Data da Publicação")),
            DataColumn(label: Text("Nº do Edital")),
            DataColumn(label: Text("Início da Vigência")),
            DataColumn(label: Text("Término da Vigência")),
            DataColumn(label: Text("Situação")),
            DataColumn(label: Text("Valor Total do Contrato")),
            DataColumn(label: Text("Ações")),
          ],
          rows: List<DataRow>.generate(data.length, (index) {
            var e = data[index].data();
            return DataRow(
              color: MaterialStateProperty.all(index % 2 != 0
                  ? Colors.white
                  : const Color.fromARGB(255, 250, 250, 250)),
              cells: <DataCell>[
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Text(
                      ugs[e.unidade] ?? '',
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ),
                DataCell(Text(e.numero)),
                DataCell(
                  SizedBox(
                    width: 300,
                    child: Text(
                      e.objeto,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ),
                DataCell(Text(
                    '${e.dataPublicacao.day.toString().padLeft(2, '0')}/${e.dataPublicacao.month.toString().padLeft(2, '0')}/${e.dataPublicacao.year}')),
                DataCell(Text(e.nrEdital)),
                DataCell(Text(
                    '${e.inicioVigencia.day.toString().padLeft(2, '0')}/${e.inicioVigencia.month.toString().padLeft(2, '0')}/${e.inicioVigencia.year}')),
                DataCell(Text(
                    '${e.terminoVigencia.day.toString().padLeft(2, '0')}/${e.terminoVigencia.month.toString().padLeft(2, '0')}/${e.terminoVigencia.year}')),
                DataCell(Text(e.situacao)),
                DataCell(Text(e.valorTotalDoContrato)),
                DataCell(TextButton(
                  child: const Text("Ver Detalhes"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: ContratoDetalhes(contrato: e),
                      ),
                    );
                  },
                )),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CampoBusca(onChanged: (text) {
          print('text');
        }),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '$_qtdContratos Resultados',
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: criarTabela(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
