import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CampoBusca extends StatefulWidget {
  CampoBusca({required this.onChanged});

  final Function onChanged;


  @override
  State<CampoBusca> createState() => _CampoBuscaState();
}

class _CampoBuscaState extends State<CampoBusca> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32.0,
          horizontal: 8.0,
        ),
        child: Center(
          child: TextField(
            onChanged: (text) {
              widget.onChanged(text);
            },
            //style: TextStyle(color: Color(0xfff1f1f1)),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              //filled: true,
              prefixIcon: Icon(Icons.search),
              labelText: 'Buscar Por Nº Contrato ou CNPJ/CPF',
            ),
          ),
        ),
      ),
    );
  }
}

