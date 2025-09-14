abstract class SchedulingData {
  /// A string identifier for the scheduling data type.
  String get type;

  Map<String, dynamic> toJson();

  /// Optionally, convert to another scheduling data type.
  SchedulingData convertTo(String targetType);
}
