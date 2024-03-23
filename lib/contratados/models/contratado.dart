class Contratado {
  String cpfCnpj;
  String nome;

  Contratado({required this.cpfCnpj, required this.nome});

  factory Contratado.fromJson(String id, Map<String, dynamic> map) {
    return Contratado(
      cpfCnpj: map['cpf_cnpj'],
      nome: map['nome'],
    );
  }
}
