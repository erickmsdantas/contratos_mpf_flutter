import 'package:contratos_mpf/contratados/models/contratado.dart';
import 'package:contratos_mpf/contratados/widgets/item_detalhe_basico.dart';
import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:flutter/material.dart';
import 'package:contratos_mpf/service.dart';

class ContratadoDetalhes extends StatefulWidget {
  ContratadoDetalhes({super.key, required this.contratado});

  Contratado contratado;

  @override
  State<ContratadoDetalhes> createState() => _ContratadoDetalhesState();
}

class _ContratadoDetalhesState extends State<ContratadoDetalhes>
    with TickerProviderStateMixin {
  List<Contrato> _contratos = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ApiService().getContratosByContratado().then((value) {
      setState(() {
        _contratos = value;
      });
    });
  }

  _titulo() {
    return ItemDetalheBasico(
      titulo: widget.contratado.nome,
      descricao: widget.contratado.cpfCnpj,
    );
  }

  _listarContratos(List<Contrato> contratos) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ..._contratos
              .map(
                (e) => ListTile(
                  title: Text(e.numero),
                  subtitle: Text(e.unidade),
                  trailing: Text('${e.inicioVigencia.day.toString().padLeft(2, '0')}/${e.inicioVigencia.month.toString().padLeft(2, '0')}/${e.inicioVigencia.year}' + ' - ' +
                      '${e.terminoVigencia.day.toString().padLeft(2, '0')}/${e.terminoVigencia.month.toString().padLeft(2, '0')}/${e.terminoVigencia.year}',),
                  tileColor: Colors.white,
                  onTap: () {
                    //onChanged(value);
                  },
                ),
              )
              .toList()
        ],
      ),
    );
  }

  _listaContratos() {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          child: TabBar(
            tabs: [
              Container(
                //width: 70.0,
                child: const Text(
                  'Ativos',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                //width: 75.0,
                child: const Text(
                  'Concluídos',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
            unselectedLabelColor: const Color(0xffacb3bf),
            indicatorColor: const Color(0xFF629784),
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3.0,
            indicatorPadding: const EdgeInsets.all(10),
            isScrollable: false,
            controller: _tabController,
          ),
        ),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _listarContratos(_contratos),
              _listarContratos(_contratos)
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DETALHES DO CONTRATADO'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titulo(),
            _listaContratos(),
          ],
        ),
      ),
    );
  }
}
