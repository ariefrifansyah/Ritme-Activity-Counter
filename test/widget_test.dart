import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:activity_counter_uts/main.dart';

void main() {
  testWidgets('Home menampilkan aktivitas awal', (tester) async {
    await tester.pumpWidget(const ActivityCounterApp());
    expect(find.text('Aktivitasku'), findsOneWidget);
    expect(find.text('Olahraga Pagi'), findsOneWidget);
    expect(find.text('Membaca Buku'), findsOneWidget);
    expect(find.text('3 aktivitas'), findsOneWidget);
  });

  testWidgets('Form menolak nama kosong', (tester) async {
    await tester.pumpWidget(const ActivityCounterApp());
    await tester.tap(find.text('Tambah Aktivitas'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save_activity_button')));
    await tester.pumpAndSettle();
    expect(find.text('Nama aktivitas tidak boleh kosong.'), findsOneWidget);
  });

  testWidgets('Counter bertambah dari halaman detail', (tester) async {
    await tester.pumpWidget(const ActivityCounterApp());
    await tester.tap(find.text('Membaca Buku'));
    await tester.pumpAndSettle();
    expect(find.text('3'), findsOneWidget);
    await tester.tap(find.byKey(const Key('increment_button')));
    await tester.pumpAndSettle();
    expect(find.text('4'), findsOneWidget);
  });
}
