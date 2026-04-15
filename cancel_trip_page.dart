import 'package:flutter/material.dart';
import 'data_storage.dart';

class CancelTripPage extends StatefulWidget {
  final Map<String, dynamic> schedule;

  const CancelTripPage({
    super.key,
    required this.schedule,
  });

  @override
  State<CancelTripPage> createState() => _CancelTripPageState();
}

class _CancelTripPageState extends State<CancelTripPage> {
  List<Map<String, dynamic>> get tripBookings {
    return DataStorage.bookings.where((booking) {
      return booking['scheduleId'] == widget.schedule['id'];
    }).toList();
  }

  void _cancelBooking(Map<String, dynamic> booking) {
    setState(() {
      DataStorage.bookings.remove(booking);

      final seats =
          int.tryParse(widget.schedule['availableSeats'].toString()) ?? 0;
      widget.schedule['availableSeats'] = seats + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Trip canceled successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF7E57C2);
    const Color lightPurple = Color(0xFFF3EEFC);
    const Color cardPurple = Color(0xFFD7C2F3);

    final route = '${widget.schedule['from']} - ${widget.schedule['to']}';

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        title: const Text(
          "Cancel Your Booking",
          style: TextStyle(
            color: mainPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: mainPurple),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: mainPurple),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: cardPurple,
              child: const Icon(
                Icons.cancel_outlined,
                size: 65,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              route,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: mainPurple,
              ),
            ),
            const SizedBox(height: 6),
            Text('Departure: ${widget.schedule['departure']}'),
            Text('Seats left: ${widget.schedule['availableSeats']}'),
            const SizedBox(height: 20),

            Expanded(
              child: tripBookings.isEmpty
                  ? const Center(
                      child: Text(
                        "No bookings for this trip",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tripBookings.length,
                      itemBuilder: (context, index) {
                        final booking = tripBookings[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(booking['passengerName']),
                            subtitle: Text(
                              'ID: ${booking['passengerId']} | Seat: ${booking['seatNumber']}',
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _cancelBooking(booking);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainPurple,
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
