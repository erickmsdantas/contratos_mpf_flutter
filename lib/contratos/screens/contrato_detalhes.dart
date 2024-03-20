import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:contratos_mpf/favoritos/models/favoritos.dart';
import 'package:contratos_mpf/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContratoDetalhes extends StatefulWidget {
  ContratoDetalhes({super.key, required this.contrato});

  Contrato contrato;

  @override
  State<StatefulWidget> createState() => _ContratoDetalhesState();
}

class _ContratoDetalhesState extends State<ContratoDetalhes> {
  _itemDetalhe(String titulo, Widget widget,
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
          child: widget,
        ),
      ],
    );
  }

  _itemDetalheBasico(String titulo, String descricao,
      {double titleSize = 16, FontWeight fontWeight = FontWeight.normal}) {
    return _itemDetalhe(
      titulo,
      Text(
        descricao,
        style: TextStyle(
          fontSize: 14,
          fontWeight: fontWeight,
          color: const Color(0xFF525252),
          fontFamily: 'Source Sans Pro',
        ),
      ),
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
    return _itemDetalheBasico(
      "Nº do Edital",
      widget.contrato.nrEdital,
    );
  }

  _unidadeMedida() {
    return _itemDetalheBasico(
      "Unidade de Medida",
      widget.contrato.unidade,
    );
  }

  _valorUnitario() {
    return _itemDetalheBasico(
      "Valor Unitário",
      widget.contrato.valorTotalDoContrato,
    );
  }

  _quantidade() {
    return _itemDetalheBasico(
      "Quantidade",
      widget.contrato.valorTotalDoContrato,
    );
  }

  _valorTotalItem() {
    return _itemDetalheBasico(
      "Valor Total do Item",
      widget.contrato.valorTotalDoContrato,
    );
  }

  _valorTotalContrato() {
    return _itemDetalheBasico(
      "Valor Total do Contrato",
      widget.contrato.valorTotalDoContrato,
    );
  }

  _itens() {
    const boldStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xFF525252),
      fontFamily: 'Source Sans Pro',
    );

    return _itemDetalhe(
      'Itens do Contrato',
      ListView.builder(
        //padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: widget.contrato.itens.length,
        itemBuilder: (BuildContext context, int index) {
          var item = widget.contrato.itens[index];
          return Card(
            //color: Colors.amber[colorCodes[index]],
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    item.itemFornecido,
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
                  child: Row(
                    children: [
                      Text('Quantidade: '),
                      Text(
                        item.quantidade,
                        style: boldStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text('Valor Unitário: '),
                      Text(
                        item.valorUnitario,
                        style: boldStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text('Valor Total: '),
                      Text(
                        item.valorTotalDoItem,
                        style: boldStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text('Unidade: '),
                      Text(
                        item.unidade,
                        style: boldStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _adicionarOuRemoverFavorito(String userId, Favoritos favoritos) {
    if (favoritos.hasContrato(widget.contrato.numero)) {
      favoritos.removerContrato(widget.contrato.numero);
    } else {
      favoritos.addContrato(widget.contrato.numero);
    }

    FirebaseRepository.instance
        .salvarFavoritos(userId, favoritos)
        .then((value) {
      setState(() {
        if (favoritos.hasContrato(widget.contrato.numero)) {
          print('has');
        }
        print('change');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<Favoritos>(
      future: FirebaseRepository.instance.getFavoritosForUser(user!.uid),
      builder: (BuildContext context, AsyncSnapshot<Favoritos> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        var favoritos = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('DETALHES DO CONTRATO'),
            actions: [
              IconButton(
                icon: Icon(favoritos.hasContrato(widget.contrato.numero)
                    ? Icons.favorite_outlined
                    : Icons.favorite_outline),
                onPressed: () {
                  _adicionarOuRemoverFavorito(user!.uid, favoritos);
                },
              ),
            ],
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
                    '${widget.contrato.inicioVigencia.day.toString().padLeft(2, '0')}/${widget.contrato.inicioVigencia.month.toString().padLeft(2, '0')}/${widget.contrato.inicioVigencia.year}' +
                        ' - ' +
                        '${widget.contrato.terminoVigencia.day.toString().padLeft(2, '0')}/${widget.contrato.terminoVigencia.month.toString().padLeft(2, '0')}/${widget.contrato.terminoVigencia.year}',
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
                    '${widget.contrato.situacao}',
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
                _nrEdital(),
                _valorTotalContrato(),
                _itens(),
              ],
            ),
          ),
        );
      },
    );
  }
}
