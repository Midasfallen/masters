enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class Booking {
  final String id;
  final String masterId;
  final String masterName;
  final String masterAvatar;
  final String serviceId;
  final String serviceName;
  final DateTime dateTime;
  final int durationMinutes;
  final String price;
  final BookingStatus status;
  final String? comment;

  Booking({
    required this.id,
    required this.masterId,
    required this.masterName,
    required this.masterAvatar,
    required this.serviceId,
    required this.serviceName,
    required this.dateTime,
    required this.durationMinutes,
    required this.price,
    required this.status,
    this.comment,
  });

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Ожидает подтверждения';
      case BookingStatus.confirmed:
        return 'Подтверждено';
      case BookingStatus.inProgress:
        return 'В процессе';
      case BookingStatus.completed:
        return 'Завершено';
      case BookingStatus.cancelled:
        return 'Отменено';
    }
  }
}
