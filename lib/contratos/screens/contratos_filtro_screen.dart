import 'package:contratos_mpf/service.dart';
import 'package:contratos_mpf/widgets/combo_box.dart';
import 'package:contratos_mpf/widgets/custom_radio_button.dart';
import 'package:contratos_mpf/widgets/custom_radio_list.dart';
import 'package:contratos_mpf/widgets/filtro_item.dart';
import 'package:contratos_mpf/widgets/filtro_item_intervalo.dart';
import 'package:contratos_mpf/widgets/filtro_item_periodo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

enum ModoExibicao { lista, tabela }

class ContratosFiltroScreen extends StatefulWidget {
  const ContratosFiltroScreen({super.key});

  @override
  State<ContratosFiltroScreen> createState() => _ContratosFiltroScreenState();
}

class _ContratosFiltroScreenState extends State<ContratosFiltroScreen> {
  final unidadesGestoras = ApiService().getUnidadesGestoras();
  List<String> _unidadesGestorasSelecionadas = [];

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
          },
        ),
      ),
      child: Column(
        children: [
          CustomRadioList<String>(
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
        selecionados: _unidadesGestorasSelecionadas.map((e) => unidadesGestoras[e]!.substring(0, 5)).toList(),
        onClick: () {
          WoltModalSheet.show<void>(
            context: context,
            pageListBuilder: (modalSheetContext) {
              final textTheme = Theme.of(context).textTheme;
              return [
                classificarContratos(modalSheetContext, textTheme),
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

  _situacao() {
    return FiltroItem(
      titulo: "Situação",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomRadioButton(
            texto: "Ativo",
            valor: 1,
            grupo: 0,
          ),
          CustomRadioButton(
            texto: "Concluido",
            valor: 2,
            grupo: 0,
          ),
        ],
      ),
    );
  }

  _vigenteEntre() {
    return FiltroItemPeriodo(
      titulo: "Vigente entre",
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

  _unidadeMedida() {
    return FiltroItem(
      titulo: "Unidade de Medida",
      child: const TextField(
        decoration: InputDecoration(
          labelText: "Unidade de Medida",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FILTRAR CONTRATOS"),
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
                    onPressed: () {},
                    child: const Text("Restaurar"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Aplicar"),
                  ),
                ],
              ),
            ),
            _unidadeGestora(context),
            _situacao(),
            _vigenteEntre(),
            _valorUnitario(),
            _valorTotalItem(),
            _valorTotalContrato(),
            _unidadeMedida(),
          ],
        ),
      ),
    );
  }
}
