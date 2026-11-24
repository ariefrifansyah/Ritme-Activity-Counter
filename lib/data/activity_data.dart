import '../models/activity_model.dart';

/// DATA: Menyimpan List selama proses aplikasi berjalan.
/// Saat aplikasi ditutup, data kembali ke tiga contoh ini.
class ActivityData {
  ActivityData({List<ActivityModel>? initialActivities})
      : activities = List<ActivityModel>.of(
          initialActivities ?? _sampleActivities,
        );

  final List<ActivityModel> activities;

  static const List<ActivityModel> _sampleActivities = [
    ActivityModel(id: 1, name: 'Morning Run', counter: 8),
    ActivityModel(id: 2, name: 'Read Book', counter: 3),
    ActivityModel(id: 3, name: 'Drink Water', counter: 5),
  ];
}
