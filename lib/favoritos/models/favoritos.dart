class Favoritos {
  String id = '';

  List<String> contratosFavoritos;
  List<String> contratadosFavoritos;
  List<String> unidadesFavoritas;

  Favoritos(
      {required this.id,
      required this.contratosFavoritos,
      required this.contratadosFavoritos,
      required this.unidadesFavoritas});

  void addContrato(String numeroContrato) {
    if (!hasContrato(numeroContrato)) {
      contratosFavoritos.add(numeroContrato);
    }
  }

  void removerContrato(String numeroContrato) {
    contratosFavoritos.remove(numeroContrato);
  }

  bool hasContrato(String numeroContrato) {
    return contratosFavoritos.contains(numeroContrato);
  }

  void addContratado(String cnpj_cpf) {
    if (!hasContratado(cnpj_cpf)) {
      contratadosFavoritos.add(cnpj_cpf);
    }
  }

  void removerContratado(String cnpj_cpf) {
    contratadosFavoritos.remove(cnpj_cpf);
  }

  bool hasContratado(String cnpj_cpf) {
    return contratadosFavoritos.contains(cnpj_cpf);
  }

  factory Favoritos.fromJson(String id, Map<String, dynamic> json) {
    return Favoritos(
      id: id,
      contratosFavoritos:
          List<String>.from(json['contratos'] ?? [] as List) ?? [],
      contratadosFavoritos:
          List<String>.from(json['contratados'] ?? [] as List) ?? [],
      unidadesFavoritas:
          List<String>.from(json['unidades'] ?? [] as List) ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contratos': contratosFavoritos,
      'contratados': contratadosFavoritos,
      'unidades': unidadesFavoritas
    };
  }
}
