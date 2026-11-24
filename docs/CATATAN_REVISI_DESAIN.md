# Revisi UI Ritme — 24 November 2026

Desain disesuaikan dengan mockup elegan yang menampilkan tiga smartphone.

## Penerapan kode

1. **Home (`home_view.dart`)**: header Ritme, sapaan dengan latar aksen organik, dua kartu statistik emerald/mint, pencarian, daftar aktivitas, dan Floating Action Button (+) lime. Tetap tersedia edit langsung dari tiap kartu.
2. **Form (`activity_form_view.dart`)**: ikon besar, judul form, input dalam panel berbingkai, saran aktivitas cepat, validasi nama dan tombol simpan bawah.
3. **Detail (`activity_detail_view.dart`)**: header aktivitas, counter gradasi beranimasi, tombol (+) / (-) bulat, tombol Reset / Hapus dengan dialog konfirmasi, dan ringkasan **total hitungan tercatat**.
4. **Tema (`main.dart`)**: sistem warna Material 3 hijau emerald, pale lime, surface cream, text ink.
5. **Data (`activity_data.dart`)**: tiga contoh menjadi Morning Run 8, Read Book 3, dan Drink Water 5, agar sesuai preview desain.

## Batasan

- Tepat **8 file Dart**, sesuai ketentuan.
- Data hanya berupa `List` in-memory; tidak ada rekam riwayat harian/mingguan. Oleh karena itu ringkasan pada halaman detail ditulis **kali tercatat**, bukan statistik mingguan yang tidak disimpan.
- Gambar dalam `preview_desain` adalah **mockup visual**, bukan screenshot aplikasi dari emulator.
- Flutter SDK tidak tersedia di lingkungan pembuatan, jadi jalankan `flutter analyze` dan `flutter run` pada komputer dengan Flutter terpasang.
