import 'package:contratos_mpf/contratados/models/contratado.dart';
import 'package:contratos_mpf/contratados/screens/contratados_detalhes.dart';
import 'package:contratos_mpf/utils/ordem.dart';
import 'package:contratos_mpf/widgets/custom_radio_list.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:page_transition/page_transition.dart';

enum ClassificacaoContratados { cnpjcpf, nome, qtdContratos }

class ContratadosLista extends StatefulWidget {
  const ContratadosLista({super.key, required this.contratados});

  final List<Contratado> contratados;

  @override
  State<ContratadosLista> createState() => _ContratadosListaState();
}

class _ContratadosListaState extends State<ContratadosLista> {
  ClassificacaoContratados _classificacaoContrato =
      ClassificacaoContratados.cnpjcpf;

  OrdemClassificacao _ordemClassificacao = OrdemClassificacao.crescente;

  SliverWoltModalSheetPage classificarContratados(
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
          onPressed: () {
            Navigator.of(modalSheetContext).pop();
          },
          child: const Text("Aplicar"),
        ),
      ),
      child: Column(
        children: [
          CustomRadioList(
            groupValue: [_classificacaoContrato],
            itens: const [
              RadioItem(
                title: "CPF/CNP",
                value: ClassificacaoContratados.cnpjcpf,
              ),
              RadioItem(
                title: "Nome",
                value: ClassificacaoContratados.nome,
              ),
              RadioItem(
                title: "Quantidade De Contratos",
                value: ClassificacaoContratados.qtdContratos,
              )
            ],
            onChange: (ClassificacaoContratados value) {
              setState(() {
                _classificacaoContrato = value;
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
              print(value.name);
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
        Text('${widget.contratados.length} Resultados'),
        const Spacer(flex: 1),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  final textTheme = Theme.of(context).textTheme;
                  return [
                    classificarContratados(modalSheetContext, textTheme),
                  ];
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
        ),
        IconButton(icon: const Icon(Icons.download), onPressed: () {}),
      ],
    );
  }

  Widget criarLista() {
    return ListView.separated(
      itemCount: widget.contratados.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 3),
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: ContratadoDetalhes(
                  contratado: widget.contratados[index],
                ),
              ),
            );
          },
          title: Text(widget.contratados[index].cpfCnpj),
          subtitle: Text(widget.contratados[index].nome),
          tileColor: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 9),
            child: mostarResultadosBusca(context),
          ),
          Expanded(
            child: criarLista(),
          ),
        ],
      ),
    );
  }
}
