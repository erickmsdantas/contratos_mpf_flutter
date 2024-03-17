import 'package:contratos_mpf/service.dart';
import 'package:contratos_mpf/utils/filtro_contratos.dart';
import 'package:contratos_mpf/widgets/combo_box.dart';
import 'package:contratos_mpf/widgets/select.dart';
import 'package:contratos_mpf/widgets/radio_button.dart';
import 'package:contratos_mpf/widgets/multiple_select.dart';
import 'package:contratos_mpf/widgets/filtro_item.dart';
import 'package:contratos_mpf/widgets/filtro_item_intervalo.dart';
import 'package:contratos_mpf/widgets/filtro_item_periodo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

enum ModoExibicao { lista, tabela }

class ContratosFiltroScreen extends StatefulWidget {
  const ContratosFiltroScreen({super.key, required this.filtroContratos});

  final FiltroContratos filtroContratos;

  @override
  State<ContratosFiltroScreen> createState() => _ContratosFiltroScreenState();
}

class _ContratosFiltroScreenState extends State<ContratosFiltroScreen> {
  final unidadesGestoras = ApiService().getUnidadesGestoras();
  List<String> _unidadesGestorasSelecionadas = [];

  FiltroContratos filtroContratos = FiltroContratos();

  @override
  void initState() {
    filtroContratos = widget.filtroContratos;
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
          MultipleSelection<String>(
            groupValue: filtroContratos.unidadesGestoras,
            itens: unidadesGestoras.entries
                .map(
                  (entry) => RadioItem(value: entry.key, title: entry.value),
                )
                .toList(),
            onChange: (List<String> value) {
              setState(() {
                setState(() {
                  filtroContratos.unidadesGestoras = value;
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
        selecionados: filtroContratos.unidadesGestoras
            .map((e) => unidadesGestoras[e]!.substring(0, 5))
            .toList(),
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
          RadioButton(
            texto: "Ativo",
            selecionado: filtroContratos.situacao.ativo,
            onChanged: (value) {
              filtroContratos.situacao =
                  (ativo: value, concluido: filtroContratos.situacao.concluido);
            },
          ),
          RadioButton(
            texto: "Concluido",
            selecionado: filtroContratos.situacao.concluido,
            onChanged: (value) {
              filtroContratos.situacao =
                  (ativo: filtroContratos.situacao.ativo, concluido: value);
            },
          ),
        ],
      ),
    );
  }

  _vigenteEntre() {
    return FiltroItemPeriodo(
      titulo: "Vigente entre",
      onChangedInicio: (ano, mes, dia) {
        filtroContratos.vigenteInicio = (ano: ano, mes: mes, dia: dia);
      },
      onChangedFim: (ano, mes, dia) {
        filtroContratos.vigenteFim = (ano: ano, mes: mes, dia: dia);
      },

    );
  }

  _valorTotalContrato() {
    return FiltroItemIntervalo(
      titulo: "Valor Total do Contrato",
      initialMin: filtroContratos.valorTotalContrato.min,
      initialMax: filtroContratos.valorTotalContrato.max,
      onChangedMin: (value) {
        filtroContratos.valorTotalContrato =
            (max: filtroContratos.valorTotalContrato.max, min: value);
      },
      onChangedMax: (value) {
        filtroContratos.valorTotalContrato =
            (max: value, min: filtroContratos.valorTotalContrato.min);
      },
    );
  }

  _unidadeMedida() {
    return FiltroItem(
      titulo: "Unidade de Medida",
      child:  TextField(
        decoration: const InputDecoration(
          labelText: "Unidade de Medida",
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {
          filtroContratos.unidadeMedida = value;
        },
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
                    onPressed: () {
                      Navigator.pop(context, FiltroContratos());
                    },
                    child: const Text("Restaurar"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, filtroContratos);
                    },
                    child: const Text("Aplicar"),
                  ),
                ],
              ),
            ),
            _unidadeGestora(context),
            _situacao(),
            _vigenteEntre(),
            /*_valorUnitario(),
            _valorTotalItem(),*/
            _valorTotalContrato(),
            _unidadeMedida(),
          ],
        ),
      ),
    );
  }
}
