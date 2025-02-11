class CatFactsApiModel {
  final String text;
  final DateTime updatedAt;

  CatFactsApiModel({required this.text, required this.updatedAt});

  factory CatFactsApiModel.fromJson(dynamic json) {
    return CatFactsApiModel(
        text: json['text'] as String,
        updatedAt: DateTime.parse(json['updatedAt'] as String));
  }
}
