// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task {
  final id, status;
  final String content;
  Task({
    required this.id,
    required this.status,
    required this.content,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'], status: json['status'], content: json['content']);
  }
}
