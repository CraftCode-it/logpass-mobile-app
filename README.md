# logpass_me

A new Flutter application.

## Init commands
- FVM use:
`fvm use 2.5.2`
- Flutter get:
`fvm flutter pub get`
- Easy localization:
`fvm flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o local_keys.g.dart`
- Build code-gen elements:
`fvm flutter pub run build_runner build --delete-conflicting-outputs `

## Build commands
Replace <env> with actual env name [dev, prod]

- iOS:
`fvm flutter build ios --flavor <env> -t lib/main_<env>.dart`
- Android:
`fvm flutter build apk --flavor <env> -t lib/main_<env>.dart`