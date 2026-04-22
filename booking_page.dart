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

  final Color mainPurple = const Color(0xFF7E57C2);
  final Color lightPurple = const Color(0xFFF3EEFC);
  final Color cardPurple = const Color(0xFFD7C2F3);

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

  bool _isFull() {
    return _getAvailableSeats() <= 0;
  }

  String _seatPreview() {
    final capacity = _getCapacity();
    final seats = _getAvailableSeats();
    return 'A${capacity - seats + 1}';
  }

  List<Map<String, dynamic>> get filteredPassengers {
    final query = searchController.text.toLowerCase();

    return DataStorage.passengers.where((p) {
      final name = (p['name'] ?? '').toString().toLowerCase();
      final id = (p['id'] ?? '').toString().toLowerCase();

      if (query.isEmpty) return true;
      return name.contains(query) || id.contains(query);
    }).toList();
  }

  bool _alreadyBookedSameTrip() {
    if (selectedPassenger == null) return false;

    return DataStorage.bookings.any((booking) {
      return booking['scheduleId'] == widget.schedule['id'] &&
          booking['passengerId'].toString() ==
              selectedPassenger!['id'].toString() &&
          booking['status'] == 'Active';
    });
  }

  void _confirmBooking() {
    final seats = _getAvailableSeats();
    final capacity = _getCapacity();

    if (_isFull()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This train is FULL")),
      );
      return;
    }

    if (_alreadyBookedSameTrip()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This passenger already has a booking for this trip"),
        ),
      );
      return;
    }

    final booking = {
      'id': 'BK${DataStorage.bookingCounter.toString().padLeft(3, '0')}',
      'scheduleId': widget.schedule['id'],
      'train': widget.schedule['train'],
      'route': '${widget.schedule['from']} - ${widget.schedule['to']}',
      'departure': widget.schedule['departure'],
      'passengerName': selectedPassenger!['name'],
      'passengerId': selectedPassenger!['id'].toString(),
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

    if (_isFull()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No seats available")),
      );
      return;
    }

    if (_alreadyBookedSameTrip()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This passenger already has a booking for this trip"),
        ),
      );
      return;
    }

    final route = '${widget.schedule['from']} - ${widget.schedule['to']}';
    final departure = (widget.schedule['departure'] ?? '').toString();
    final ticket = (widget.schedule['ticket'] ?? 0).toString();
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
              Text("Price: $ticket SAR"),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: mainPurple,
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
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
          Text('$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final from = (widget.schedule['from'] ?? '').toString();
    final to = (widget.schedule['to'] ?? '').toString();
    final departure = (widget.schedule['departure'] ?? '').toString();
    final arrival = (widget.schedule['arrival'] ?? '').toString();
    final ticket = (widget.schedule['ticket'] ?? 0).toString();
    final seats = _getAvailableSeats();

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: mainPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Book Your Trip",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: cardPurple,
              child: const Icon(Icons.train, size: 75, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Book Your Trip",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _infoBox("From", from),
            _infoBox("To", to),
            _infoBox("Departure", departure),
            _infoBox("Arrival", arrival),
            _infoBox("Ticket Price", "$ticket SAR"),
            _infoBox(
              "Seats Left",
              _isFull() ? "FULL" : seats.toString(),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: "Search Passenger (Name or ID)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 12),

            if (selectedPassenger != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Selected: ${selectedPassenger!['name']} | ID: ${selectedPassenger!['id']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            SizedBox(
              height: 220,
              child: filteredPassengers.isEmpty
                  ? const Center(child: Text("No passengers found"))
                  : ListView.builder(
                      itemCount: filteredPassengers.length,
                      itemBuilder: (context, index) {
                        final p = filteredPassengers[index];

                        return Card(
                          child: ListTile(
                            title: Text((p['name'] ?? '').toString()),
                            subtitle: Text("ID: ${(p['id'] ?? '').toString()}"),
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

            const SizedBox(height: 20),

            SizedBox(
              width: 140,
              height: 50,
              child: ElevatedButton(
                onPressed: _isFull() ? null : _showBookingSummary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainPurple,
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
