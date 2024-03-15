import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  RadioButton(
      {super.key,
      required this.texto,
      required this.selecionado,
      required this.onChanged});

  String texto;
  bool selecionado;
  final ValueChanged<bool> onChanged;

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return OutlinedButton(
      onPressed: () {
        setState(() {
          widget.selecionado = !widget.selecionado;
          widget.onChanged(widget.selecionado);
        });
      },
      child: Row(
        children: [
          widget.selecionado
              ? const Icon(Icons.radio_button_on)
              : const Icon(Icons.radio_button_off),
          Text(
            widget.texto,
            style: TextStyle(
              color: (widget.selecionado) ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
