@echo off
setlocal
where flutter >nul 2>nul
if errorlevel 1 (
    echo Flutter belum ditemukan. Install Flutter SDK dan masukkan folder bin ke PATH.
    echo Panduan: https://docs.flutter.dev/get-started/install
    pause
    exit /b 1
)

echo === Membuat file platform Android dan Web dari Flutter SDK Anda ===
call flutter create --project-name activity_counter_uts --platforms=android,web .
if errorlevel 1 exit /b 1

echo === Menghapus file test Dart bawaan yang tidak diizinkan struktur ===
if exist "test\widget_test.dart" del /q "test\widget_test.dart"

echo === Mengunduh dependencies ===
call flutter pub get
if errorlevel 1 exit /b 1

echo === Menjalankan aplikasi ===
call flutter run
endlocal
