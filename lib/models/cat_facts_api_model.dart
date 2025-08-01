// ignore_for_file: avoid_dynamic_calls

class CatFactsApiModel {
  final String text;
  final DateTime updatedAt;

  CatFactsApiModel({required this.text, required this.updatedAt});

  factory CatFactsApiModel.fromJson(dynamic json) {
    return CatFactsApiModel(text: json as String, updatedAt: DateTime.now());
  }
}
