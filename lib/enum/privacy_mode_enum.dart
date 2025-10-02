enum PrivacyMode {
  private,
  protected,
  public;

  // Encode to API (int: 0, 1, 2).
  int toJson() => index;

  // Decode from API (expects int 0, 1, or 2).
  static PrivacyMode fromJson(dynamic json) {
    if (json is int && json >= 0 && json < PrivacyMode.values.length) {
      return PrivacyMode.values[json];
    }
    return PrivacyMode.private; // Default value
  }
}
