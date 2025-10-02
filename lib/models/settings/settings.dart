class SettingsModel {
  String url;

  SettingsModel({
    required this.url,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      url: json['url']?.toString() ?? 'https://api.example.com/',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
