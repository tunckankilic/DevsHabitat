class ProfilePrivacySettings {
  final bool showEmail;
  final bool showLocation;
  final bool showCurrentCompany;
  final bool showSalaryExpectations;
  final bool showAvailability;

  ProfilePrivacySettings({
    required this.showEmail,
    required this.showLocation,
    required this.showCurrentCompany,
    required this.showSalaryExpectations,
    required this.showAvailability,
  });

  factory ProfilePrivacySettings.fromMap(Map<String, dynamic> map) {
    return ProfilePrivacySettings(
      showEmail: map['showEmail'] as bool? ?? false,
      showLocation: map['showLocation'] as bool? ?? false,
      showCurrentCompany: map['showCurrentCompany'] as bool? ?? false,
      showSalaryExpectations: map['showSalaryExpectations'] as bool? ?? false,
      showAvailability: map['showAvailability'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showEmail': showEmail,
      'showLocation': showLocation,
      'showCurrentCompany': showCurrentCompany,
      'showSalaryExpectations': showSalaryExpectations,
      'showAvailability': showAvailability,
    };
  }
}
