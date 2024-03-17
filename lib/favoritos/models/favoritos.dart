import 'package:contratos_mpf/favoritos/models/favorito.dart';

class Favoritos {
  String id = '';

  List<String> contratosFavoritos;

  Favoritos({required this.id, required this.contratosFavoritos});

  void addContrato(String numeroContrato) {
    contratosFavoritos.add(numeroContrato);
  }

  bool hasContrato(String numeroContrato) {
    return contratosFavoritos.contains(numeroContrato);
  }

  factory Favoritos.fromJson(String id, Map<String, dynamic> json) {
    print(json);
    return Favoritos(id: id, contratosFavoritos: List<String>.from(json['contratos'] as List) ?? []);
  }

  Map<String, dynamic> toJson() {
    return {'contratos': contratosFavoritos};
  }
}
