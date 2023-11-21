// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppDataSettings _$AppDataSettingsFromJson(Map<String, dynamic> json) =>
    AppDataSettings(
      json['startDate'] as int,
      json['lastOpenDate'] as String,
      daysOpened: json['daysOpened'] as int? ?? 1,
      showAdvancedSettings: json['showAdvancedSettings'] as bool? ?? false,
    );

Map<String, dynamic> _$AppDataSettingsToJson(AppDataSettings instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'lastOpenDate': instance.lastOpenDate,
      'daysOpened': instance.daysOpened,
      'showAdvancedSettings': instance.showAdvancedSettings,
    };
