class Reservation {
  String date;
  String reservationId;
  String countOfPeople;
  String userId;
  String vendorId;
  String time;
  String status;

  Reservation({
    required this.date,
    required this.countOfPeople,
    required this.userId,
    required this.reservationId,
    required this.vendorId,
    required this.time,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      date: json['date'],
      reservationId: json['id'],
      countOfPeople: json['count_of_people'],
      userId: json['user_id'],
      vendorId: json['vendor_id'],
      time: json['time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['id'] = this.reservationId;
    data['count_of_people'] = this.countOfPeople;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['time'] = this.time;
    data['status'] = this.status;
    return data;
  }
}
