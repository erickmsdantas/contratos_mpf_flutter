import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:flutter/material.dart';

class ContratoDetalhes extends StatefulWidget {
  ContratoDetalhes({super.key, required this.contrato});

  Contrato contrato;

  @override
  State<StatefulWidget> createState() => _ContratoDetalhesState();
}

class _ContratoDetalhesState extends State<ContratoDetalhes> {
  _itemDetalheBasico(String titulo, String descricao,
      {double titleSize = 16, FontWeight fontWeight = FontWeight.normal}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Color(0xFF525252),
              fontFamily: 'Source Sans Pro',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
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

  _ug() {
    return _itemDetalheBasico(
      "UG",
      widget.contrato.unidade,
    );
  }

  /*_itemFornecido()
  {
    return _itemDetalheBasico("Item Fornecido", widget.contrato.itemFornecido);
  }*/

  _nrEdital() {
    return _itemDetalheBasico("Nº do Edital", widget.contrato.nrEdital,);
  }

  _unidadeMedida() {
    return _itemDetalheBasico("Unidade de Medida", widget.contrato.unidade,);
  }

  _valorUnitario() {
    return _itemDetalheBasico("Valor Unitário", widget.contrato.valorTotalDoContrato,);
  }

  _quantidade() {
    return _itemDetalheBasico("Quantidade", widget.contrato.valorTotalDoContrato,);
  }

  _valorTotalItem() {
    return _itemDetalheBasico("Valor Total do Item", widget.contrato.valorTotalDoContrato,);
  }

  _valorTotalContrato() {
    return _itemDetalheBasico("Valor Total do Contrato", widget.contrato.valorTotalDoContrato,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DETALHES DO CONTRATO'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.contrato.numero,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF525252),
                  fontFamily: 'Source Sans Pro',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.contrato.objeto,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF525252),
                  fontFamily: 'Source Sans Pro',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '${widget.contrato.inicioVigencia.day.toString().padLeft(2, '0')}/${widget.contrato.inicioVigencia.month.toString().padLeft(2, '0')}/${widget.contrato.inicioVigencia.year}' + ' - ' +
                '${widget.contrato.terminoVigencia.day.toString().padLeft(2, '0')}/${widget.contrato.terminoVigencia.month.toString().padLeft(2, '0')}/${widget.contrato.terminoVigencia.year}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF525252),
                  fontFamily: 'Source Sans Pro',
                ),
              ),
            ),
            const Divider(height: 1),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Contratado",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF525252),
                  fontFamily: 'Source Sans Pro',
                ),
              ),
            ),
            ListTile(
              title: Text(widget.contrato.contratado),
              subtitle: Text(widget.contrato.contratado),
              tileColor: Colors.white,
              trailing: const Icon(Icons.chevron_right),
            ),
            //
            const Divider(height: 1),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Sócios",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF525252),
                  fontFamily: 'Source Sans Pro',
                ),
              ),
            ),
            ListTile(
              title: Text(widget.contrato.contratado),
              subtitle: Text(widget.contrato.contratado),
              tileColor: Colors.white,
              trailing: const Icon(Icons.chevron_right),
            ),
            //
            _ug(),
            // _itemFornecido(),
            _nrEdital(),
            _unidadeMedida(),
            _valorUnitario(),
            _quantidade(),
            _valorTotalItem(),
            _valorTotalContrato(),
          ],
        ),
      ),
    );
  }
}
