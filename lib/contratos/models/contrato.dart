import 'package:contratos_mpf/contratos/models/item.dart';
import 'package:contratos_mpf/utils/date_time.dart';

class Contrato {
  String numero = '';
  String unidade = '';
  String objeto = '';
  String dataPublicacao = '';
  String nrEdital = '';
  DateTime inicioVigencia = DateTime.now();
  DateTime terminoVigencia = DateTime.now();
  String situacao = '';
  String valorTotalDoContrato = '';
  String contratado = '';
  List<String> socios = [];

  List<Item> itens = [];

  Contrato();

  Contrato.fromJson(String id, Map<String, dynamic> json) {
    numero = id.toString().replaceAll('.', '/');
    unidade = json['ug'];
    objeto = json['objeto'];
    dataPublicacao = json['data_publicacao'];
    nrEdital = json['nr_edital'];
    inicioVigencia = json['inicio'].toDate();
    terminoVigencia = json['termino'].toDate();
    situacao = json['situacao'];
    valorTotalDoContrato = json['valor_total'].toString();
    contratado = json['contratado'];
    itens =
        List<Item>.from(json['itens']?.map((item) => Item.fromMap(item)) ?? []);
  }
}
