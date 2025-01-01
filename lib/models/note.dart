class Note {
  final int? id; // ID tự tăng
  final String title; // Tiêu đề
  final String content; // Nội dung
  final DateTime createdDate; // Ngày tạo
  final int? taskId; // Liên kết với công việc (nếu có)

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdDate,
    this.taskId,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdDate: DateTime.parse(map['createdDate']),
      taskId: map['taskId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'taskId': taskId,
    };
  }
}
