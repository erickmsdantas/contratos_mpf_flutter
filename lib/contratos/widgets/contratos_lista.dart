import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratos_mpf/contratos/screens/contrato_detalhes.dart';
import 'package:contratos_mpf/contratos/widgets/campo_busca.dart';
import 'package:contratos_mpf/firebase_repository.dart';
import 'package:contratos_mpf/utils/ordem.dart';
import 'package:contratos_mpf/widgets/select.dart';
import 'package:contratos_mpf/widgets/multiple_select.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:async/async.dart' show StreamGroup;
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

import '../../utils/filtro_contratos.dart';
import '../models/contrato.dart';

const double _pageBreakpoint = 768.0;

enum ClassificacaoContratos {
  cnpjcpf,
  nrContrato,
  inicioVigencia,
  terminoVigencia
}

class ContratosModoLista extends StatefulWidget {
  ContratosModoLista({super.key, required this.filtroContratos});

  FiltroContratos filtroContratos;

  @override
  State<ContratosModoLista> createState() => _ContratosModoListaState();
}

class _ContratosModoListaState extends State<ContratosModoLista> {
  String textoBusca = '';

  ClassificacaoContratos _classificacaoContratos =
      ClassificacaoContratos.cnpjcpf;

  OrdemClassificacao _ordemClassificacao = OrdemClassificacao.crescente;

  @override
  void initState() {
    super.initState();
  }

  SliverWoltModalSheetPage classificarContratos(
      BuildContext modalSheetContext, TextTheme textTheme) {
    return WoltModalSheetPage(
      hasSabGradient: false,
      topBarTitle: Container(
        alignment: Alignment.centerLeft,
        constraints: const BoxConstraints.expand(),
        child: const Text(
          'ORDERNAR POR',
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF525252),
          ),
        ),
      ),
      isTopBarLayerAlwaysVisible: true,
      trailingNavBarWidget: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextButton(
          child: const Text("Aplicar"),
          onPressed: () {
            Navigator.of(modalSheetContext).pop();
            setState(() {});
          },
        ),
      ),
      child: Column(
        children: [
          Select(
            groupValue: _classificacaoContratos,
            itens: const [
              SelectItem(
                title: "Número do Contrato",
                value: ClassificacaoContratos.nrContrato,
              ),
              SelectItem(
                title: "CPF/CNP",
                value: ClassificacaoContratos.cnpjcpf,
              ),
              SelectItem(
                title: "Início Vigência",
                value: ClassificacaoContratos.inicioVigencia,
              ),
              SelectItem(
                title: "Termino Vigência",
                value: ClassificacaoContratos.terminoVigencia,
              )
            ],
            onChange: (ClassificacaoContratos value) {
              _classificacaoContratos = value;
            },
          ),
          const Divider(),
          Select(
            groupValue: _ordemClassificacao,
            itens: const [
              SelectItem(
                title: "Crescente",
                value: OrdemClassificacao.crescente,
              ),
              SelectItem(
                title: "Decrescente",
                value: OrdemClassificacao.decrescente,
              )
            ],
            onChange: (OrdemClassificacao value) {
              _ordemClassificacao = value;
            },
          ),
        ],
      ),
    );
  }

  Widget mostarResultadosBusca(BuildContext context, qtdContratos) {
    return Row(
      children: [
        Text(
          '$qtdContratos Resultados',
        ),
        const Spacer(flex: 1),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            WoltModalSheet.show<void>(
              context: context,
              pageListBuilder: (modalSheetContext) {
                final textTheme = Theme.of(context).textTheme;
                return [
                  classificarContratos(modalSheetContext, textTheme),
                ];
              },
              modalTypeBuilder: (context) {
                final size = MediaQuery.of(context).size.width;
                if (size < _pageBreakpoint) {
                  return WoltModalType.bottomSheet;
                } else {
                  return WoltModalType.dialog;
                }
              },
              onModalDismissedWithBarrierTap: () {
                Navigator.of(context).pop();
              },
              maxDialogWidth: 560,
              minDialogWidth: 400,
              minPageHeight: 0.0,
              maxPageHeight: 0.9,
            );
          },
        ),
        IconButton(icon: const Icon(Icons.download), onPressed: () {}),
      ],
    );
  }

  Widget _createContratoList(item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            child: ContratoDetalhes(contrato: item),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  item.numero,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF525252),
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${item.inicioVigencia.day.toString().padLeft(2, '0')}/${item.inicioVigencia.month.toString().padLeft(2, '0')}/${item.inicioVigencia.year}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.contratado,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Source Sans Pro',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${item.terminoVigencia.day.toString().padLeft(2, '0')}/${item.terminoVigencia.month.toString().padLeft(2, '0')}/${item.terminoVigencia.year}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget criarLista() {
    List<Stream<QuerySnapshot>> streams = [];

    CollectionReference<Contrato> collection =
        FirebaseRepository.instance.contratosCollection;

    Query<Contrato> query1 = collection.limit(100); //_buildQuery(collection);
    Query query2 = collection.limit(100); //_buildQuery(collection);

    if (widget.filtroContratos.unidadesGestoras.length > 0) {
      query1 =
          query1.where('ug', whereIn: widget.filtroContratos.unidadesGestoras);
    }

    if (widget.filtroContratos.situacao.ativo !=
        widget.filtroContratos.situacao.concluido) {
      if (widget.filtroContratos.situacao.ativo) {
        query1 = query1.where('situacao', isEqualTo: 'ativo');
      } else {
        query1 = query1.where('situacao', isEqualTo: 'concluído');
      }
    }

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
        startDate =
            DateTime(int.parse(widget.filtroContratos.vigenteInicio.ano), 1, 1);
      }

      query1 = query1.where('inicio',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate)).orderBy('inicio');
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
        dataFinal =
            DateTime(int.parse(widget.filtroContratos.vigenteFim.ano), 1, 1);
      }

      query1 = query1.where('termino',
          isLessThanOrEqualTo: Timestamp.fromDate(dataFinal)).orderBy('termino');
    }

    //
    //
    //

    if (widget.filtroContratos.valorTotalContrato.min > 0) {
      query1 = query1.where('valor_total',
          isGreaterThanOrEqualTo:
              widget.filtroContratos.valorTotalContrato.min);
    }

    if (widget.filtroContratos.valorTotalContrato.max > 0) {
      query1 = query1.where('valor_total',
          isLessThanOrEqualTo: widget.filtroContratos.valorTotalContrato.max);
    }

    //
    //
    //

    if (textoBusca.isNotEmpty) {
      query1 = query1
          .where('nr_contrato', isGreaterThanOrEqualTo: textoBusca)
          .where('nr_contrato', isLessThanOrEqualTo: textoBusca + '\uf8ff');

      query2 = query2
          .where('contratado', isGreaterThanOrEqualTo: textoBusca)
          .where('contratado', isLessThanOrEqualTo: textoBusca + '\uf8ff');
    }

    query1 = orderBy(query1);

    streams.add(query1.snapshots());
    // /streams.add(query2.snapshots());

    return FirestoreQueryBuilder<Contrato>(
      query: query1,
      pageSize: 5,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          print('error ${snapshot.error}');
          return Text('error ${snapshot.error}');
        }

        final data = snapshot.docs;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: FutureBuilder<AggregateQuerySnapshot>(
                  future: query1
                      .count()
                      .get(), // a previously-obtained Future<String> or null
                  builder: (BuildContext context,
                      AsyncSnapshot<AggregateQuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return mostarResultadosBusca(
                          context, snapshot.data!.count);
                    } else
                      return Text("");
                  }),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.hasMore && index + 1 == data.length) {
                    // Tell FirestoreQueryBuilder to try to obtain more items.
                    // It is safe to call this function from within the build method.
                    snapshot.fetchMore();
                  }

                  return _createContratoList(data.elementAt(index).data());
                },
              ),
            ),
          ],
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
          onChanged: (text) {
            setState(() {
              textoBusca = text;
            });
          },
        ),
        Expanded(
          child: criarLista(),
        ),
      ],
    );
  }
}
