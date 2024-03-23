class FiltroContratos {
  List<String> unidadesGestoras = [];
  ({bool ativo, bool concluido}) situacao = (ativo: false, concluido: false);
  ({String ano, String mes, String dia}) vigenteInicio =
      (ano: '', mes: '', dia: '');
  ({String ano, String mes, String dia}) vigenteFim =
      (ano: '', mes: '', dia: '');
  ({double min, double max}) valorTotalContrato = (min: 0.0, max: 0.0);
}
