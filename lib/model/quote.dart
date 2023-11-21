import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable()
class Quote {
  String id;
  String title;
  String message;
  String exercise;
  int dateCreated;

  Quote({
    required this.id,
    required this.title,
    required this.message,
    required this.exercise,
    required this.dateCreated,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteToJson(this);

  @override
  String toString() {
    return "Title: $title, message: $message, exercise: $exercise, date: $dateCreated";
  }
}
