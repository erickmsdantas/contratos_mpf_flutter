import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FiltroItem extends StatelessWidget {
  FiltroItem({required this.titulo, required this.child});

  String titulo;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontFamily: 'Source Sans Pro',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF525252),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          color: Colors.white,
          child: child,
        ),
      ],
    );
  }

}