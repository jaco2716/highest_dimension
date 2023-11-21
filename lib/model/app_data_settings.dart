import 'package:json_annotation/json_annotation.dart';

part 'app_data_settings.g.dart';

@JsonSerializable()
class AppDataSettings {
  int startDate;
  String lastOpenDate;
  int daysOpened;
  bool showAdvancedSettings;

  AppDataSettings(
    this.startDate,
    this.lastOpenDate, {
    this.daysOpened = 1,
    this.showAdvancedSettings = false,
  });

  factory AppDataSettings.fromJson(Map<String, dynamic> json) => _$AppDataSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppDataSettingsToJson(this);
}

enum SharedPrefNames {
  appDataSettings,
}
