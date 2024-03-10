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

const double _pageBreakpoint = 768.0;

enum ClassificacaoContratos {
  cnpjcpf,
  nrContrato,
  inicioVigencia,
  terminoVigencia
}

class ContratosModoLista extends StatefulWidget {
  ContratosModoLista({super.key});

  @override
  State<ContratosModoLista> createState() => _ContratosModoListaState();
}

class _ContratosModoListaState extends State<ContratosModoLista> {
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
    CollectionReference collection =
        FirebaseRepository.instance.contratosCollection;
    Query query = _buildQuery(collection);


    return StreamBuilder(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Center();

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        final data = snapshot.requireData;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: mostarResultadosBusca(context, data.docs.length),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: data.docs.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(
                  height: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _createContratoList(data.docs.elementAt(index).data());
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Query _buildQuery(CollectionReference collection) {
    switch (_classificacaoContratos) {
      case ClassificacaoContratos.inicioVigencia:
        return collection.orderBy('inicio',
            descending: _ordemClassificacao == OrdemClassificacao.decrescente);
      case ClassificacaoContratos.terminoVigencia:
        return collection.orderBy('termino',
            descending: _ordemClassificacao == OrdemClassificacao.decrescente);
      case ClassificacaoContratos.cnpjcpf:
        return collection.orderBy('contratado',
            descending: _ordemClassificacao == OrdemClassificacao.decrescente);
      default:
        return collection.orderBy(FieldPath.documentId,
            descending: _ordemClassificacao == OrdemClassificacao.decrescente);
    }
  }

    @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CampoBusca(),
        Expanded(
          child: criarLista(),
        ),
      ],
    );
  }
}
