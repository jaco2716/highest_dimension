# highest_dimension

Created: 7/11/2023
Flutter SDK: v3.13.9

## Commands

### Build iOS/Android Archive:

Remember to change version! (version: 1.0.0+1 -> 1.0.1+2)

- flutter build ipa
- flutter build appbundle

---

## Commands

### Build JsonSerializable model classes:

```yaml
dependencies:
  json_annotation: ^4.8.0 #use @command:dart.addDependency

dev_dependencies:
  build_runner: ^2.3.3 #use @command:dart.addDevDependency
  json_serializable: ^6.6.0 #use @command:dart.addDevDependency
```

```dart
//Imports: Replace FILENAME
import 'package:json_annotation/json_annotation.dart';
part 'FILENAME.g.dart';
//Add above class
@JsonSerializable()
//Replace NAME with class
factory NAME.fromJson(Map<String, dynamic> json) => _$NAMEFromJson(json);
Map<String, dynamic> toJson() => _$NAMEToJson(this);
```

- flutter pub run build_runner build
- flutter pub run build_runner watch

---

### Launcher Icons

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

# Add Launcher icon run: flutter pub run flutter_launcher_icons
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  #Optional for adaptive icons
  image_path_ios: "assets/icon/icon.png"
  #Forground image needs to be max 682px icon inside 1024px image with transparent border
  adaptive_icon_foreground: "assets/icon/icon-android.png"
  adaptive_icon_background: "#ffffff"
```

- flutter pub run flutter_launcher_icons

---

## Useful config setup

### IOS - NonExemptEncryption:false

```plist
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

<details>
<summary>Screen Orientaion (Portrait olnly)</summary>

Input in main.dart -> MyApp -> after `Widget build(BuildContext context) {`

```dart
SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
```

For iOS (To work on iPad)

```plist
<array>
  <string>UIInterfaceOrientationPortrait</string>
</array>
```

</details>

### Google Cloud Platform

Restore backup

- gcloud firestore import gs://ab_one_firestore_backup/[EXPORT FOLDER NAME]
