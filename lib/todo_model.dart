// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TodoModel {
  String? title;
  bool? isCompleted;
  TodoModel({
    this.title,
    this.isCompleted,
  });

  TodoModel copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return TodoModel(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      title: map['title'] != null ? map['title'] as String : null,
      isCompleted:
          map['isCompleted'] != null ? map['isCompleted'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TodoModel(title: $title, isCompleted: $isCompleted)';

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => title.hashCode ^ isCompleted.hashCode;
}
