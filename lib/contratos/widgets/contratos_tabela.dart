import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:contratos_mpf/contratos/widgets/campo_busca.dart';
import 'package:contratos_mpf/contratos/widgets/contratos_lista.dart';
import 'package:contratos_mpf/firebase_repository.dart';
import 'package:contratos_mpf/service.dart';
import 'package:contratos_mpf/contratos/screens/contrato_detalhes.dart';
import 'package:contratos_mpf/utils/ordem.dart';
import '../../utils/filtro_contratos.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class ContratosModoTabela extends StatefulWidget {
  ContratosModoTabela({super.key, required this.filtroContratos});

  FiltroContratos filtroContratos;

  @override
  State<ContratosModoTabela> createState() => _ContratosModoTabelaState();
}

class _ContratosModoTabelaState extends State<ContratosModoTabela> {
  TextEditingController controller = TextEditingController();

  String textoBusca = '';

  ClassificacaoContratos _classificacaoContratos =
      ClassificacaoContratos.cnpjcpf;

  OrdemClassificacao _ordemClassificacao = OrdemClassificacao.crescente;

  String _qtdContratos = '';

  @override
  void initState() {
    super.initState();
  }

  Widget criarTabela() {
    CollectionReference<Contrato> collection =
        FirebaseRepository.instance.contratosCollection;

    Query<Contrato> query1;

    if (textoBusca.isNotEmpty) {
      query1 = collection
          .where('nr_contrato', isGreaterThanOrEqualTo: textoBusca)
          .where('nr_contrato', isLessThanOrEqualTo: textoBusca + '\uf8ff');
    } else {
      query1 = orderBy(collection);

      if (widget.filtroContratos.unidadesGestoras.length > 0) {
        query1 = query1.where('ug',
            whereIn: widget.filtroContratos.unidadesGestoras);
      }

      if (widget.filtroContratos.situacao.ativo !=
          widget.filtroContratos.situacao.concluido) {
        if (widget.filtroContratos.situacao.ativo) {
          query1 = query1.where('situacao', isEqualTo: 'ativo');
        } else {
          query1 = query1.where('situacao', isEqualTo: 'concluído');
        }
      }

      if (widget.filtroContratos.vigenteInicio.ano.isNotEmpty ||
          widget.filtroContratos.vigenteFim.ano.isNotEmpty) {
        if (widget.filtroContratos.vigenteInicio.ano.isNotEmpty) {
          DateTime startDate;

          if (widget.filtroContratos.vigenteInicio.mes.isNotEmpty &&
              widget.filtroContratos.vigenteInicio.dia.isNotEmpty) {
            startDate = DateTime(
                int.parse(widget.filtroContratos.vigenteInicio.ano),
                int.parse(widget.filtroContratos.vigenteInicio.mes),
                int.parse(widget.filtroContratos.vigenteInicio.dia));
          } else if (widget.filtroContratos.vigenteInicio.mes.isNotEmpty) {
            startDate = DateTime(
                int.parse(widget.filtroContratos.vigenteInicio.ano),
                int.parse(widget.filtroContratos.vigenteInicio.mes),
                1);
          } else {
            startDate = DateTime(
                int.parse(widget.filtroContratos.vigenteInicio.ano), 1, 1);
          }

          query1 = query1.where('inicio',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
        }

        if (widget.filtroContratos.vigenteFim.ano.isNotEmpty) {
          DateTime dataFinal;

          if (widget.filtroContratos.vigenteFim.mes.isNotEmpty &&
              widget.filtroContratos.vigenteFim.dia.isNotEmpty) {
            dataFinal = DateTime(
                int.parse(widget.filtroContratos.vigenteFim.ano),
                int.parse(widget.filtroContratos.vigenteFim.mes),
                int.parse(widget.filtroContratos.vigenteFim.dia));
          } else if (widget.filtroContratos.vigenteFim.mes.isNotEmpty) {
            dataFinal = DateTime(
                int.parse(widget.filtroContratos.vigenteFim.ano),
                int.parse(widget.filtroContratos.vigenteFim.mes),
                1);
          } else {
            dataFinal = DateTime(
                int.parse(widget.filtroContratos.vigenteFim.ano), 1, 1);
          }

          query1 = query1
              .where('termino',
              isLessThanOrEqualTo: Timestamp.fromDate(dataFinal))
              .orderBy('termino');
        }
      } else {
        if (widget.filtroContratos.valorTotalContrato.min > 0) {
          query1 = query1.where('valor_total',
              isGreaterThanOrEqualTo:
              widget.filtroContratos.valorTotalContrato.min);
        }

        if (widget.filtroContratos.valorTotalContrato.max > 0) {
          query1 = query1
              .where('valor_total',
              isLessThanOrEqualTo:
              widget.filtroContratos.valorTotalContrato.max)
              .orderBy('valor_total');
        }
      }

      if (widget.filtroContratos.valorTotalContrato.max > 0) {
        query1 = query1.orderBy('valor_total');
      }

      if (widget.filtroContratos.vigenteInicio.ano.isNotEmpty) {
        query1 = query1.orderBy('inicio');
      }
    }

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
                    '${e.dataPublicacao}')),
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


  Query<Contrato> orderBy(Query<Contrato> query) {
    switch (_classificacaoContratos) {
      case ClassificacaoContratos.inicioVigencia:
        return query.orderBy('inicio',
            descending: _ordemClassificacao == OrdemClassificacao.decrescente);
      case ClassificacaoContratos.terminoVigencia:
        return query.orderBy('termino',
            descending: _ordemClassificacao == OrdemClassificacao.decrescente);
      case ClassificacaoContratos.cnpjcpf:
        return query.orderBy('contratado',
            descending: _ordemClassificacao == OrdemClassificacao.decrescente);
      default:
        return query.orderBy('nr_contrato',
            descending: _ordemClassificacao == OrdemClassificacao.decrescente);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CampoBusca(
          isContratado: true,
          onChanged: (text) {
            print('text');
          },
        ),
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
