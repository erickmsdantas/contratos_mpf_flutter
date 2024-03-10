import 'package:contratos_mpf/nav_menu.dart';
import 'package:contratos_mpf/observar/models/observacao.dart';
import 'package:contratos_mpf/service.dart';
import 'package:contratos_mpf/widgets/combo_box.dart';
import 'package:contratos_mpf/widgets/multiple_select.dart';
import 'package:contratos_mpf/widgets/filtro_item.dart';
import 'package:contratos_mpf/widgets/filtro_item_intervalo.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class NovaObservacaoScreen extends StatefulWidget {
  const NovaObservacaoScreen({super.key});

  @override
  State<NovaObservacaoScreen> createState() =>
      _NovaObservacaoScreenScreenState();
}

class _NovaObservacaoScreenScreenState extends State<NovaObservacaoScreen> {
  final unidadesGestoras = ApiService().getUnidadesGestoras();

  List<String> _unidadesGestorasSelecionadas = [];

  SliverWoltModalSheetPage selecionarUnidadesGestoras(
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
          MultipleSelection<String>(
            groupValue: _unidadesGestorasSelecionadas,
            itens: unidadesGestoras.entries
                .map(
                  (entry) => RadioItem(value: entry.key, title: entry.value),
                )
                .toList(),
            onChange: (List<String> value) {
              setState(() {
                setState(() {
                  _unidadesGestorasSelecionadas = value;
                });
              });
            },
          ),
        ],
      ),
    );
  }

  _unidadeGestora(context) {
    return FiltroItem(
      titulo: "Unidade Gestora",
      child: ComboBox(
        selecionados: _unidadesGestorasSelecionadas
            .map((e) => unidadesGestoras[e]!.substring(0, 5))
            .toList(),
        onClick: () {
          WoltModalSheet.show<void>(
            context: context,
            pageListBuilder: (modalSheetContext) {
              final textTheme = Theme.of(context).textTheme;
              return [
                selecionarUnidadesGestoras(modalSheetContext, textTheme),
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
    );
  }

  _campoCNPJCPF() {
    return FiltroItem(
      titulo: "CNPJ/CPF",
      child: TextField(
        decoration: InputDecoration(
          labelText: 'CNPJ/CPF',
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  _valorUnitario() {
    return FiltroItemIntervalo(
      titulo: "Valor Unitário",
    );
  }

  _valorTotalItem() {
    return FiltroItemIntervalo(
      titulo: "Valor Total do Item",
    );
  }

  _valorTotalContrato() {
    return FiltroItemIntervalo(
      titulo: "Valor Total do Contrato",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NOVA OBSERVAÇÃO"),
        centerTitle: true,
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
                    child: const Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Aplicar"),
                  ),
                ],
              ),
            ),
            _campoCNPJCPF(),
            _unidadeGestora(context),
            _valorUnitario(),
            _valorTotalItem(),
            _valorTotalContrato(),
          ],
        ),
      ),
    );
  }
}
