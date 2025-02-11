class CatPictureApiModel {
  final String url;

  CatPictureApiModel({
    required this.url,
  });

  factory CatPictureApiModel.fromJson(dynamic json) {
    return CatPictureApiModel(
      url: json['url'] as String,
    );
  }
}
