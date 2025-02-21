import 'package:json_annotation/json_annotation.dart';

part 'day_note.g.dart';

@JsonSerializable()
class DayNote {
  DateTime Date;
  String Message;
  bool Cancelled = false;

  DayNote({required this.Date, required this.Message});

  factory DayNote.fromJson(Map<String, dynamic> json) => _$DayNoteFromJson(json);

  Map<String, dynamic> toJson() => _$DayNoteToJson(this);
}
