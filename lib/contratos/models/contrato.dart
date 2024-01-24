class Contrato {
  String numero = '';
  String unidade = '';
  String objeto = '';
  DateTime dataPublicacao = DateTime.now();
  String nrEdital = '';
  DateTime inicioVigencia = DateTime.now();
  DateTime terminoVigencia = DateTime.now();
  String situacao = '';
  String itemFornecido = '';
  String valorTotalDoContrato = '';
  String contratado = '';
  List<String> socios = [];

  String valorUnitario = '';
  String quantidade = '';
  String valorTotalDoItem = '';


  Contrato();

  Contrato.fromJson(Map<String, dynamic> json) {
    numero = json['numero'];
    unidade = json['unidade'];
    objeto = json['objeto'];
    dataPublicacao = DateTime.parse(json['data_publicacao']);
    contratado = json['contratado']['identificador'];
  }
}
