#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo 'Flutter SDK belum ada di PATH: https://docs.flutter.dev/get-started/install'
  exit 1
fi

echo 'Membuat berkas platform Android dan Web sesuai Flutter SDK lokal...'
flutter create --project-name activity_counter_uts --platforms=android,web .
# Flutter create dapat membuat test/widget_test.dart bawaan.
# Hapus agar hanya ada delapan file Dart sesuai instruksi UTS.
rm -f test/widget_test.dart
flutter pub get
flutter run
