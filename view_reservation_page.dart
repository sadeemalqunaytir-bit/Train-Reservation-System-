import 'package:flutter/material.dart';
import 'data_storage.dart';

class ViewReservationsPage extends StatefulWidget {
  final Map<String, dynamic> schedule;

  const ViewReservationsPage({
    super.key,
    required this.schedule,
  });

  @override
  State<ViewReservationsPage> createState() => _ViewReservationsPageState();
}

class _ViewReservationsPageState extends State<ViewReservationsPage> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> get filteredBookings {
    final query = searchController.text.toLowerCase();

    return DataStorage.bookings.where((booking) {
      final sameSchedule = booking['scheduleId'] == widget.schedule['id'];

      final matchesSearch =
          booking['id'].toString().toLowerCase().contains(query) ||
          booking['passengerName'].toString().toLowerCase().contains(query) ||
          booking['passengerId'].toString().toLowerCase().contains(query) ||
          booking['seatNumber'].toString().toLowerCase().contains(query) ||
          booking['status'].toString().toLowerCase().contains(query);

      return sameSchedule && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF7E57C2);
    const Color lightPurple = Color(0xFFF3EEFC);

    final route = '${widget.schedule['from']} - ${widget.schedule['to']}';
    final departure = widget.schedule['departure']?.toString() ?? '';
    final seatsLeft = widget.schedule['availableSeats']?.toString() ?? '0';

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        title: const Text(
          "View Reservations",
          style: TextStyle(
            color: mainPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: mainPurple),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFD7C2F3),
              child: Icon(Icons.train, color: mainPurple),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Divider(height: 2, thickness: 2, color: mainPurple),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search..',
                prefixIcon: const Icon(Icons.search, color: mainPurple),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                route,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                departure,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Seats left: $seatsLeft',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: filteredBookings.isEmpty
                  ? const Center(
                      child: Text(
                        'No reservations for this trip',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor:
                              WidgetStatePropertyAll(Colors.grey.shade300),
                          columns: const [
                            DataColumn(label: Text('Ticket ID')),
                            DataColumn(label: Text('Passenger Name')),
                            DataColumn(label: Text('Passenger ID')),
                            DataColumn(label: Text('Seat Number')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: filteredBookings.map((booking) {
                            return DataRow(
                              cells: [
                                DataCell(Text(booking['id'].toString())),
                                DataCell(Text(booking['passengerName'].toString())),
                                DataCell(Text(booking['passengerId'].toString())),
                                DataCell(Text(booking['seatNumber'].toString())),
                                DataCell(Text(booking['status'].toString())),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
