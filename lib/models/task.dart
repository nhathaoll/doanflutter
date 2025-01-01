class Task {
  final int? id; // ID tự tăng
  final String title; // Tiêu đề
  final DateTime deadline; // Hạn chót
  final int categoryId; // Liên kết danh mục
  final int priority; // Mức độ ưu tiên: 1 (thấp), 2 (trung bình), 3 (cao)
  final bool isCompleted; // Trạng thái hoàn thành

  Task({
    this.id,
    required this.title,
    required this.deadline,
    required this.categoryId,
    required this.priority,
    required this.isCompleted,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      deadline: DateTime.parse(map['deadline']),
      categoryId: map['categoryId'],
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline.toIso8601String(),
      'categoryId': categoryId,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
