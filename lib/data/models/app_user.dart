// app_user.dart
class AppUser {
  final String email;
  final String phoneNumber;
  String? id;

  AppUser({
    required this.email,
    required this.phoneNumber,
    this.id,
  });

  // Optionally, add methods like toJson, fromJson, etc.
}