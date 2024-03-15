class FiltroContratos {
  List<String> unidadesGestoras = [];
  ({bool ativo, bool concluido}) situacao = (ativo: false, concluido: false);
  //({String inicio, String fim}) vigenteEntre = (0, 0);
  ({double min, double max}) valorUnitario = (min: 0.0, max: 0.0);
  ({double min, double max}) valorTotalItem = (min: 0.0, max: 0.0);
  ({double min, double max}) valorTotalContrato = (min: 0.0, max: 0.0);
}
