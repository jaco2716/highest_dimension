// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      exercise: json['exercise'] as String,
      dateCreated: json['dateCreated'] as int,
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'exercise': instance.exercise,
      'dateCreated': instance.dateCreated,
    };
