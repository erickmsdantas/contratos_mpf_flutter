import 'package:flutter/cupertino.dart';

class ItemDetalheBasico extends StatelessWidget {
  ItemDetalheBasico(
      {required this.titulo,
      required this.descricao,
      this.titleSize = 16,
      this.fontWeight = FontWeight.normal});

  String titulo;
  String descricao;

  double titleSize = 16;
  FontWeight fontWeight = FontWeight.normal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF525252),
              fontFamily: 'Source Sans Pro',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            descricao,
            style: TextStyle(
              fontSize: 14,
              fontWeight: fontWeight,
              color: const Color(0xFF525252),
              fontFamily: 'Source Sans Pro',
            ),
          ),
        ),
      ],
    );
  }
}
