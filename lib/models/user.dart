class User {
  final String email;
  final String? password;
  final String authMethod; // 'email' or 'google'

  User({required this.email, this.password, required this.authMethod});

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password, 'authMethod': authMethod};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] ?? '',
      password: map['password'],
      authMethod: map['authMethod'] ?? 'email',
    );
  }

  User copyWith({String? email, String? password, String? authMethod}) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      authMethod: authMethod ?? this.authMethod,
    );
  }
}
