class Category {
  final int? id; // ID tự tăng trong SQLite
  final String name; // Tên danh mục
  final String color; // Mã màu dạng hex
  final DateTime createdDate; // Ngày tạo danh mục

  Category({
    this.id,
    required this.name,
    required this.color,
    required this.createdDate,
  });

  // Tạo Category từ Map (dữ liệu SQLite)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      createdDate: DateTime.parse(map['createdDate']),
    );
  }

  // Chuyển Category thành Map để lưu trữ trong SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}
