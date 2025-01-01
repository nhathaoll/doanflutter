class Event {
  final int? id; // ID tự tăng
  final String title; // Tiêu đề sự kiện
  final DateTime dateTime; // Thời gian
  final int categoryId; // ID danh mục liên kết
  final String description; // Mô tả sự kiện
  final bool isCompleted; // Trạng thái hoàn thành

  Event({
    this.id,
    required this.title,
    required this.dateTime,
    required this.categoryId,
    required this.description,
    required this.isCompleted,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      dateTime: DateTime.parse(map['dateTime']),
      categoryId: map['categoryId'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'categoryId': categoryId,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
