import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  CustomRadioButton(
      {super.key, required this.texto, required this.valor, required this.grupo});

  String texto;
  int valor;
  int grupo;

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return OutlinedButton(
      onPressed: () {
        setState(() {
          if (widget.valor == widget.grupo) {
            widget.valor = -1;
          } else {
            widget.valor = widget.grupo;
          }
        });
      },
      child: Row(
        children: [
          widget.valor == widget.grupo
              ? const Icon(Icons.radio_button_on)
              : const Icon(Icons.radio_button_off),
          Text(
            widget.texto,
            style: TextStyle(
              color:
                  (widget.valor == widget.grupo) ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
