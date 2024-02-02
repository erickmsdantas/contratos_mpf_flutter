import 'package:contratos_mpf/constants.dart';
import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:contratos_mpf/contratos/screens/contrato_detalhes.dart';
import 'package:contratos_mpf/contratos/widgets/campo_busca.dart';
import 'package:contratos_mpf/service.dart';
import 'package:contratos_mpf/utils/ordem.dart';
import 'package:contratos_mpf/widgets/custom_radio_list.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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

  int qtdContratos = 0;

  final PagingController<int, Contrato> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await ApiService().getContratos();

      setState(() {
        qtdContratos = newItems.length;
      });

      final isLastPage = newItems.length < ApiConstants.pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
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
          },
        ),
      ),
      child: Column(
        children: [
          CustomRadioList(
            groupValue: [_classificacaoContratos],
            itens: const [
              RadioItem(
                title: "CPF/CNP",
                value: ClassificacaoContratos.cnpjcpf,
              ),
              RadioItem(
                title: "Início Vigência",
                value: ClassificacaoContratos.inicioVigencia,
              ),
              RadioItem(
                title: "Termino Vigência",
                value: ClassificacaoContratos.terminoVigencia,
              )
            ],
            onChange: (ClassificacaoContratos value) {
              setState(() {
                _classificacaoContratos = value;
              });
            },
          ),
          const Divider(),
          CustomRadioList(
            groupValue: [_ordemClassificacao],
            itens: const [
              RadioItem(
                title: "Crescente",
                value: OrdemClassificacao.crescente,
              ),
              RadioItem(
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

  Widget mostarResultadosBusca(BuildContext context) {
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

  Widget criarLista() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, Contrato>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Contrato>(
          animateTransitions: true,
          itemBuilder: (context, item, index) => GestureDetector(
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
          ),
        ),
        separatorBuilder: (context, index) => Container(
          padding: const EdgeInsets.only(bottom: 3),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CampoBusca(),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: mostarResultadosBusca(context),
        ),
        Expanded(
          child: criarLista(),
        ),
      ],
    );
  }
}
