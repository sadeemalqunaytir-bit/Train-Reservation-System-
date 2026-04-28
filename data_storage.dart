class DataStorage {
  static final List<Map<String, dynamic>> trains = [];
  static final List<Map<String, dynamic>> schedules = [];

  static int bookingCounter = 1;
  static List<Map<String, dynamic>> bookings = [];

  static List<Map<String, dynamic>> passengers = [];
}



bool isTrainFull(Map<String, dynamic> schedule) {
  final seats = int.tryParse(schedule['availableSeats'].toString()) ?? 0;
  return seats <= 0;
}

int seatsLeft(Map<String, dynamic> schedule) {
  return int.tryParse(schedule['availableSeats'].toString()) ?? 0;
}

int capacity(Map<String, dynamic> schedule) {
  return int.tryParse(schedule['capacity'].toString()) ?? 0;
}


// New helper functions for booking reports

int totalBookings() {
  return DataStorage.bookings.length;
}

int confirmedBookings() {
  return DataStorage.bookings
      .where((booking) =>
          booking['status'] == 'Confirmed' || booking['status'] == 'Active')
      .length;
}

int cancelledBookings() {
  return DataStorage.bookings
      .where((booking) => booking['status'] == 'Cancelled')
      .length;
}
