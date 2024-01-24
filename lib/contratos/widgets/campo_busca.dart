import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CampoBusca extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 32.0,
          horizontal: 8.0,
        ),
        child: Center(
          child: TextField(
            obscureText: true,
            //style: TextStyle(color: Color(0xfff1f1f1)),
            decoration: InputDecoration(
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

