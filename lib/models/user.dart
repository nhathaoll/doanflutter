class User {
  final int? id; // ID tự tăng
  final String name; // Tên
  final String email; // Email
  final String? avatarUrl; // Ảnh đại diện
  final DateTime createdDate; // Ngày tạo

  User({
    this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.createdDate,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
      createdDate: DateTime.parse(map['createdDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}
