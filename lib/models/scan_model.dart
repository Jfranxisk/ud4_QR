import 'dart:convert';

class ScanModel {
    ScanModel({
        this.id,
        this.tipus,
        required this.valor,
    }){
      this.tipus = this.valor.contains('http') ? 'http' : 'geo';
    }

    int? id;
    String? tipus;
    String valor;

    factory ScanModel.fromJson(String str) => ScanModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ScanModel.fromMap(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipus: json["tipus"],
        valor: json["valor"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "tipus": tipus,
        "valor": valor,
    };
}