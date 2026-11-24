import 'package:flutter_test/flutter_test.dart';
import 'package:activity_counter_uts/data/activity_data.dart';
import 'package:activity_counter_uts/models/activity_model.dart';
import 'package:activity_counter_uts/repositories/activity_repository.dart';
import 'package:activity_counter_uts/viewmodels/activity_viewmodel.dart';

void main() {
  late ActivityViewModel viewModel;

  setUp(() {
    viewModel = ActivityViewModel(
      ActivityRepository(ActivityData(initialActivities: [])),
    );
  });

  tearDown(() => viewModel.dispose());

  test('Menambahkan aktivitas dan memulai counter dari 0', () {
    expect(viewModel.addActivity('  Jogging  '), isTrue);
    expect(viewModel.activities.single.name, 'Jogging');
    expect(viewModel.activities.single.counter, 0);
    expect(viewModel.addActivity('  '), isFalse);
    expect(viewModel.activities.length, 1);
  });

  test('Counter tidak pernah kurang dari nol', () {
    viewModel.addActivity('Baca buku');
    final id = viewModel.activities.single.id;

    expect(viewModel.decrementCounter(id), isFalse);
    expect(viewModel.activityById(id)!.counter, 0);
    expect(viewModel.incrementCounter(id), isTrue);
    expect(viewModel.incrementCounter(id), isTrue);
    expect(viewModel.decrementCounter(id), isTrue);
    expect(viewModel.activityById(id)!.counter, 1);
    expect(viewModel.resetCounter(id), isTrue);
    expect(viewModel.activityById(id)!.counter, 0);
    expect(viewModel.resetCounter(id), isFalse);
  });

  test('Mengedit nama tidak mengubah nilai counter', () {
    viewModel.addActivity('Awal');
    final id = viewModel.activities.single.id;
    viewModel.incrementCounter(id);
    expect(viewModel.renameActivity(id, '  Sesudah  '), isTrue);
    expect(viewModel.activityById(id)!.name, 'Sesudah');
    expect(viewModel.activityById(id)!.counter, 1);
    expect(viewModel.renameActivity(id, ''), isFalse);
  });

  test('Menghapus aktivitas, ID baru tetap unik', () {
    viewModel.addActivity('A');
    final idLama = viewModel.activities.single.id;
    expect(viewModel.deleteActivity(idLama), isTrue);
    expect(viewModel.activities, isEmpty);
    viewModel.addActivity('B');
    expect(viewModel.activities.single.id, isNot(idLama));
  });

  test('Perubahan yang berhasil memanggil notifyListeners', () {
    var updateCount = 0;
    viewModel.addListener(() => updateCount++);
    viewModel.addActivity('Tugas');
    final id = viewModel.activities.single.id;
    viewModel.incrementCounter(id);
    viewModel.renameActivity(id, 'Tugas Kampus');
    viewModel.deleteActivity(id);
    expect(updateCount, 4);
  });

  test('Repository mengembalikan daftar yang tidak dapat dimodifikasi', () {
    final repository = ActivityRepository(ActivityData(initialActivities: []));
    final snapshot = repository.getAllActivities();
    expect(() => snapshot.add(const ActivityModel(id: 99, name: 'Test')),
        throwsUnsupportedError);
  });
}
