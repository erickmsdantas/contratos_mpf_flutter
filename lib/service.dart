import 'dart:convert';
import 'dart:io';
import 'package:contratos_mpf/contratados/models/contratado.dart';
import 'package:contratos_mpf/contratos/models/contrato.dart';
import 'package:http/http.dart' as http;

class ApiService {

  Map<String, String> getUnidadesGestoras() {
    return {
      "200009": "MPDFT - MINISTÉRIO PÚBLICO DO DF. E TERRITÓRIOS",
      "200008": "MPM - MINISTÉRIO PÚBLICO MILITAR",
      "200200": "MPT - MINISTÉRIO PÚBLICO DO TRABALHO",
      "200100": "PGR - PROCURADORIA GERAL DA REPUBLICA",
      "200069": "PR-AC - PROCURADORIA DA REPUBLICA - ACRE",
      "200093": "PR-AL - PROCURADORIA DA REPUBLICA - ALAGOAS",
      "380005": "PR-AP - PROCURADORIA DA REPUBLICA - AMAPA",
      "200071": "PR-AM - PROCURADORIA DA REPUBLICA - AMAZONAS",
      "200031": "PR-BA - PROCURADORIA DA REPUBLICA - BAHIA",
      "200082": "PR-CE - PROCURADORIA DA REPUBLICA - CEARA",
      "200023": "PR-DF - PROCURADORIA DA REPUBLICA - DISTRITO FEDERAL",
      "200038": "PR-ES - PROCURADORIA DA REPUBLICA - ESPIRITO SANTO",
      "200066": "PR-GO - PROCURADORIA DA REPUBLICA - GOIAS",
      "200078": "PR-MA - PROCURADORIA DA REPUBLICA - MARANHAO",
      "200064": "PR-MT - PROCURADORIA DA REPUBLICA - MATO GROSSO",
      "200040": "PR-MS - PROCURADORIA DA REPUBLICA - MATO GROSSO DO SUL",
      "200035": "PR-MG - PROCURADORIA DA REPUBLICA - MINAS GERAIS",
      "200075": "PR-PA - PROCURADORIA DA REPUBLICA - PARA",
      "200087": "PR-PB - PROCURADORIA DA REPUBLICA - PARAIBA",
      "200053": "PR-PR - PROCURADORIA DA REPUBLICA - PARANA",
      "200090": "PR-PE - PROCURADORIA DA REPUBLICA - PERNAMBUCO",
      "200080": "PR-PI - PROCURADORIA DA REPUBLICA - PIAUI",
      "200043": "PR-RJ - PROCURADORIA DA REPUBLICA - RIO DE JANEIRO",
      "200085": "PR-RN - PROCURADORIA DA REPUBLICA - RIO GRANDE DO NORTE",
      "200061": "PR-RS - PROCURADORIA DA REPUBLICA - RIO GRANDE DO SUL",
      "200046": "PR-RO - PROCURADORIA DA REPUBLICA - RONDONIA",
      "380006": "PR-RR - PROCURADORIA DA REPUBLICA - RORAIMA",
      "200058": "PR-SC - PROCURADORIA DA REPUBLICA - SANTA CATARINA",
      "200049": "PR-SP - PROCURADORIA DA REPUBLICA - SAO PAULO",
      "200022": "PR-SE - PROCURADORIA DA REPUBLICA - SERGIPE",
      "200201": "PR-TO - PROCURADORIA DA REPUBLICA - TOCANTINS",
      "200208": "PRR1ª REGIÃO - PRR/1ª REGIAO - BRASILIA",
      "200045": "PRR2ª REGIÃO - PRR/2ª REGIAO - RIO DE JANEIRO",
      "200204": "PRR3ª REGIÃO - PRR/3ª REGIAO - SAO PAULO",
      "200102": "PRR4ª REGIÃO - PRR/4ª REGIAO - PORTO ALEGRE",
      "200207": "PRR5ª REGIÃO - PRR/5ª REGIAO - RECIFE",
      "200700": "PRR6ª REGIÃO - PRR/6ª REGIAO - MINAS GERAIS",
      "200800":
          "SEPLAN/MPU - SECRETARIA DO PROG. SAÚDE E ASSISTÊNCIA SOCIAL/MPU",
    };
  }

  //
  //

  static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) {
    return jsonArray.map(mapper).toList();
  }

  Future<R> mapFromResponse<R, T>(
      http.Response response, R Function(T) jsonParser) async {
    try {
      if (response.statusCode == 200) {
        return jsonParser(jsonDecode(response.body));
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}

extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
    try {
      final response = await this;
      if (response.statusCode == 200) {
        print(jsonParser(jsonDecode(response.body)));
        return jsonParser(jsonDecode(response.body));
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }
}
