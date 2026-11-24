import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';

/// VIEWMODEL: Menangani logika interaksi, lalu notifyListeners() ke View.
class ActivityViewModel extends ChangeNotifier {
  ActivityViewModel(this._repository);

  final ActivityRepository _repository;

  List<ActivityModel> get activities => _repository.getAllActivities();

  ActivityModel? activityById(int id) => _repository.getActivityById(id);

  int get totalCounter =>
      activities.fold<int>(0, (total, activity) => total + activity.counter);

  bool addActivity(String name) {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return false;

    _repository.addActivity(cleanName);
    notifyListeners();
    return true;
  }

  bool renameActivity(int id, String newName) {
    final cleanName = newName.trim();
    if (cleanName.isEmpty) return false;

    final success = _repository.updateActivityName(id, cleanName);
    if (success) notifyListeners();
    return success;
  }

  bool incrementCounter(int id) {
    final activity = activityById(id);
    if (activity == null) return false;

    final success = _repository.updateCounter(id, activity.counter + 1);
    if (success) notifyListeners();
    return success;
  }

  bool decrementCounter(int id) {
    final activity = activityById(id);
    if (activity == null || activity.counter == 0) return false;

    final success = _repository.updateCounter(id, activity.counter - 1);
    if (success) notifyListeners();
    return success;
  }

  bool resetCounter(int id) {
    final success = _repository.updateCounter(id, 0);
    if (success) notifyListeners();
    return success;
  }

  bool deleteActivity(int id) {
    final success = _repository.deleteActivity(id);
    if (success) notifyListeners();
    return success;
  }
}

/// Menghubungkan ViewModel ke ketiga halaman tanpa package tambahan.
/// InheritedNotifier otomatis membangun ulang View saat notifyListeners().
class ActivityScope extends InheritedNotifier<ActivityViewModel> {
  const ActivityScope({
    super.key,
    required ActivityViewModel viewModel,
    required super.child,
  }) : super(notifier: viewModel);

  static ActivityViewModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ActivityScope>();
    assert(scope != null, 'ActivityScope tidak ditemukan pada widget tree.');
    return scope!.notifier!;
  }
}
