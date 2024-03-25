class Contratado {
  String cpfCnpj;
  String nome;
  bool temContratoAtivo;

  Contratado({required this.cpfCnpj, required this.nome, required this.temContratoAtivo});

  factory Contratado.fromJson(String id, Map<String, dynamic> map) {
    return Contratado(
      cpfCnpj: map['cpf_cnpj'],
      nome: map['nome'],
      temContratoAtivo: map['tem_contrato_ativo'],
    );
  }
}
