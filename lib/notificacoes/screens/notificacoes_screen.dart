import 'dart:collection';

import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:contratos_mpf/nav_menu.dart';
import 'package:contratos_mpf/service.dart';
import 'package:contratos_mpf/utils/date_time.dart';
import 'package:flutter/material.dart';

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  SplayTreeMap<DateTime, List<Contrato>> notificacoesByData = SplayTreeMap();

  @override
  void initState() {
    super.initState();
      _getData();
  }

  void _getData() async {
    /*var contratos = (await ApiService().getContratos())!;
    setState(() {
      notificacoesByData[DateTime(2023, 9)] = contratos;
      notificacoesByData[DateTime(2023, 10)] = contratos;
    });*/
  }

  Widget mostratNotificacao(DateTime data, List<Contrato> contratos) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
          child: Text(
            "${DateTimeUtils.meses[data.month]} de ${data.year}",
            style: const TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF525252),
            ),
            textAlign: TextAlign.left,
          ),
        ),
        ...contratos
            .map((e) => ListTile(
                  title: Text(e.numero),
                  subtitle: Text(e.unidade),
                  trailing: Text(
                    '${e.inicioVigencia.day.toString().padLeft(2, '0')}/${e.inicioVigencia.month.toString().padLeft(2, '0')}/${e.inicioVigencia.year} - ${e.terminoVigencia.day.toString().padLeft(2, '0')}/${e.terminoVigencia.month.toString().padLeft(2, '0')}/${e.terminoVigencia.year}',
                  ),
                  tileColor: Colors.white,
                ))
            .toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavMenu(),
      appBar: AppBar(
        title: const Text("NOTIFICAÇÕES"),
        centerTitle: true,
      ),
      body: Column(
          children: notificacoesByData.entries
              .map((entries) => mostratNotificacao(entries.key, entries.value))
              .toList()
              .reversed
              .toList()),
    );
  }
}
