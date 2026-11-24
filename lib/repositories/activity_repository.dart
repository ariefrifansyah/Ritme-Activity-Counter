import '../data/activity_data.dart';
import '../models/activity_model.dart';

/// REPOSITORY: Satu-satunya lapisan yang memanipulasi isi ActivityData.
class ActivityRepository {
  ActivityRepository(this._data) {
    // ID baru tetap unik meskipun aktivitas lama sudah dihapus.
    for (final activity in _data.activities) {
      if (activity.id >= _nextId) {
        _nextId = activity.id + 1;
      }
    }
  }

  final ActivityData _data;
  int _nextId = 1;

  /// Mengembalikan salinan read-only, bukan List asli dalam Data.
  List<ActivityModel> getAllActivities() {
    return List<ActivityModel>.unmodifiable(_data.activities);
  }

  ActivityModel? getActivityById(int id) {
    for (final activity in _data.activities) {
      if (activity.id == id) return activity;
    }
    return null;
  }

  ActivityModel addActivity(String name) {
    final activity = ActivityModel(id: _nextId++, name: name);
    _data.activities.add(activity);
    return activity;
  }

  bool updateActivityName(int id, String newName) {
    final index = _indexOf(id);
    if (index == -1) return false;
    _data.activities[index] = _data.activities[index].copyWith(name: newName);
    return true;
  }

  bool updateCounter(int id, int newValue) {
    if (newValue < 0) return false;
    final index = _indexOf(id);
    if (index == -1) return false;
    if (_data.activities[index].counter == newValue) return false;

    _data.activities[index] =
        _data.activities[index].copyWith(counter: newValue);
    return true;
  }

  bool deleteActivity(int id) {
    final index = _indexOf(id);
    if (index == -1) return false;
    _data.activities.removeAt(index);
    return true;
  }

  int _indexOf(int id) {
    return _data.activities.indexWhere((activity) => activity.id == id);
  }
}
