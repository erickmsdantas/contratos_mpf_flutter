import 'package:contratos_mpf/widgets/currency_input.dart';
import 'package:contratos_mpf/widgets/filtro_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FiltroItemIntervalo extends StatelessWidget {
  FiltroItemIntervalo({
    super.key,
    required this.titulo,
    required this.onChangedMin,
    required this.onChangedMax,
    double this.initialMin = 0,
    double this.initialMax = 0,
    required this.readOnly,
  });

  String titulo;

  double initialMin = 0;
  double initialMax = 0;

  final Function onChangedMin;
  final Function onChangedMax;

  bool readOnly;

  @override
  Widget build(BuildContext context) {
    NumberFormat numberFormat = NumberFormat.decimalPattern('pt_BR');

    print(readOnly);

    return FiltroItem(
      titulo: titulo,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CurrencyInput(
                labelText: "Mínimo",
                initialValue:
                    initialMin == 0 ? '' : numberFormat.format(initialMin),
                onChanged: (value) {
                  onChangedMin(numberFormat.parse(value));
                },
                readOnly: readOnly,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: CurrencyInput(
                labelText: "Máximo",
                initialValue:
                    initialMax == 0 ? '' : numberFormat.format(initialMax),
                onChanged: (value) {
                  onChangedMax(numberFormat.parse(value));
                },
                readOnly: readOnly,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
