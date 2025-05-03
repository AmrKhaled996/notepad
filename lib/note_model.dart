import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String content;
  
  @HiveField(3)
  DateTime date;
  
  @HiveField(4)
  bool isTodo;
  
  @HiveField(5)
  List<String> tags;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.isTodo = false,
    this.tags = const [],
  });
  Note copyWith({
  String? id,
  String? title,
  String? content,
  DateTime? date,
  bool? isTodo,
  List<String>? tags,
}) {
  return Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    date: date ?? this.date,
    isTodo: isTodo ?? this.isTodo,
    tags: tags ?? this.tags,
  );
}
}
