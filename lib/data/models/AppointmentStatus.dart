enum AppointmentStatus {
  pending(0),
  completed(1),
  cancelled(2);

  final int value;
  const AppointmentStatus(this.value);

  static AppointmentStatus fromValue(int value) {
    return AppointmentStatus.values.firstWhere(
          (status) => status.value == value,
      orElse: () => AppointmentStatus.pending,
    );
  }
}