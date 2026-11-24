/// MODEL: Mendefinisikan satu aktivitas beserta nilai penghitungnya.
///
/// Objek dibuat immutable agar perubahan hanya dilakukan melalui Repository.
class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.name,
    this.counter = 0,
  });

  final int id;
  final String name;
  final int counter;

  ActivityModel copyWith({String? name, int? counter}) {
    return ActivityModel(
      id: id,
      name: name ?? this.name,
      counter: counter ?? this.counter,
    );
  }
}
