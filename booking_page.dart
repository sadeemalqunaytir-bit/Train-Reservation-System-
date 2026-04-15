import 'package:flutter/material.dart';
import 'data_storage.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> schedule;

  const BookingPage({
    super.key,
    required this.schedule,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController searchController = TextEditingController();

  Map<String, dynamic>? selectedPassenger;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  int _getCapacity() {
    return int.tryParse(widget.schedule['capacity'].toString()) ?? 0;
  }

  int _getAvailableSeats() {
    return int.tryParse(widget.schedule['availableSeats'].toString()) ?? 0;
  }

  String _seatPreview() {
    final capacity = _getCapacity();
    final seats = _getAvailableSeats();
    return 'A${capacity - seats + 1}';
  }

  List<Map<String, dynamic>> get filteredPassengers {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      return DataStorage.passengers;
    }

    return DataStorage.passengers.where((p) {
      final name = p['name']?.toString().toLowerCase() ?? '';
      final id = p['id']?.toString().toLowerCase() ?? '';
      return name.contains(query) || id.contains(query);
    }).toList();
  }

  void _confirmBooking() {
    final seats = _getAvailableSeats();
    final capacity = _getCapacity();

    final booking = {
      'id': 'BK${DataStorage.bookingCounter.toString().padLeft(3, '0')}',
      'scheduleId': widget.schedule['id'],
      'train': widget.schedule['train'],
      'route': '${widget.schedule['from']} - ${widget.schedule['to']}',
      'departure': widget.schedule['departure'],
      'passengerName': selectedPassenger!['name'],
      'passengerId': selectedPassenger!['id'],
      'seatNumber': 'A${capacity - seats + 1}',
      'status': 'Active',
    };

    setState(() {
      widget.schedule['availableSeats'] = seats - 1;
      DataStorage.bookings.add(booking);
      DataStorage.bookingCounter++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking successful")),
    );

    Navigator.pop(context);
  }

  void _showBookingSummary() {
    final seats = _getAvailableSeats();

    if (selectedPassenger == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a passenger")),
      );
      return;
    }

    if (widget.schedule['id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Schedule ID is missing")),
      );
      return;
    }

    if (seats <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No seats available")),
      );
      return;
    }

    final route = '${widget.schedule['from']} - ${widget.schedule['to']}';
    final departure = widget.schedule['departure']?.toString() ?? '';
    final ticket = widget.schedule['ticket']?.toString() ?? '';
    final seat = _seatPreview();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Booking Summary"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Trip: $route"),
              Text("Departure: $departure"),
              Text("Passenger Name: ${selectedPassenger!['name']}"),
              Text("Passenger ID: ${selectedPassenger!['id']}"),
              Text("Seat Number: $seat"),
              Text("Ticket Price: $ticket SAR"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmBooking();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Widget _infoBox(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final from = widget.schedule['from']?.toString() ?? '';
    final to = widget.schedule['to']?.toString() ?? '';
    final departure = widget.schedule['departure']?.toString() ?? '';
    final arrival = widget.schedule['arrival']?.toString() ?? '';
    final ticket = widget.schedule['ticket']?.toString() ?? '';
    final seats = _getAvailableSeats();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoBox("From", from),
            _infoBox("To", to),
            _infoBox("Departure", departure),
            _infoBox("Arrival", arrival),
            _infoBox("Ticket Price", "$ticket SAR"),
            _infoBox("Seats Left", seats.toString()),

            const SizedBox(height: 10),

            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: "Search Passenger (Name or ID)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            if (selectedPassenger != null)
              Card(
                color: Colors.green.shade100,
                child: ListTile(
                  title: Text(selectedPassenger!['name']),
                  subtitle: Text("ID: ${selectedPassenger!['id']}"),
                ),
              ),

            const SizedBox(height: 10),

            Expanded(
              child: filteredPassengers.isEmpty
                  ? const Center(child: Text("No passengers found"))
                  : ListView.builder(
                      itemCount: filteredPassengers.length,
                      itemBuilder: (context, index) {
                        final p = filteredPassengers[index];

                        return Card(
                          child: ListTile(
                            title: Text(p['name'] ?? ''),
                            subtitle: Text("ID: ${p['id']}"),
                            onTap: () {
                              setState(() {
                                selectedPassenger = p;
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _showBookingSummary,
                child: const Text("Book Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
