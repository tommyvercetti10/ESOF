class UserPreferences {
  final String uuid;
  final bool isDarkMode;

  UserPreferences({required this.uuid, required this.isDarkMode});

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'isDarkMode': isDarkMode ? 1 : 0,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      uuid: map['uuid'],
      isDarkMode: map['isDarkMode'] == 1,
    );
  }
}
