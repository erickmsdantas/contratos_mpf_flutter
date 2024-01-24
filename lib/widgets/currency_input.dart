import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    List<String> split = newValue.text.split(',');
    String parteReais = split[0].replaceAll('.', '');
    String? parteCent = split.length > 1 ? split[1] : null;

    if (parteCent != null) print(parteCent);

    String newText = '';

    int count = 0;
    for (int i = parteReais.length - 1; i >= 0; i--) {
      newText = parteReais[i] + newText;
      count++;

      if (count == 3 && i != 0) {
        newText = '.$newText';
        count = 0;
      }
    }

    if (parteCent != null) {
      parteCent = ',${parteCent.substring(0, parteCent.length > 2 ? 2 : parteCent.length)}';
      newText = newText + parteCent;
    }

    final int selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length - selectionIndexFromTheRight));
  }
}

class CurrencyInput extends StatelessWidget {
  CurrencyInput({super.key, required this.labelText});

  String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        label: Row(children: [
          const Text("R\$ "),
          Text(labelText),
        ],),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        CurrencyInputFormatter(),
      ],
    );
  }

}