import 'package:contratos_mpf/widgets/currency_input.dart';
import 'package:contratos_mpf/widgets/date_field.dart';
import 'package:contratos_mpf/widgets/filtro_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FiltroItemPeriodo extends StatelessWidget {
  FiltroItemPeriodo({super.key, required this.titulo});

  String titulo;

  @override
  Widget build(BuildContext context) {
    return FiltroItem(
      titulo: titulo,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: DateField(
                labelText: 'Início',
                onChanged: () {},
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: DateField(
                labelText: 'Fim',
                onChanged: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
