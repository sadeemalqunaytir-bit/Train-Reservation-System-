import 'package:flutter/material.dart';
import 'data_storage.dart';
import 'booking_page.dart';
import 'cancel_trip_page.dart';
import 'view_reservation_page.dart';

class SelectTripPage extends StatefulWidget {
  final String mode; // booking / cancel / view

  const SelectTripPage({
    super.key,
    required this.mode,
  });

  @override
  State<SelectTripPage> createState() => _SelectTripPageState();
}

class _SelectTripPageState extends State<SelectTripPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF7E57C2);
    const Color lightPurple = Color(0xFFF3EEFC);

    final allSchedules = DataStorage.schedules;

    String pageTitle = 'Select Trip';
    if (widget.mode == 'booking') {
      pageTitle = 'Booking A Trip';
    } else if (widget.mode == 'cancel') {
      pageTitle = 'Cancel Trip';
    } else if (widget.mode == 'view') {
      pageTitle = 'View Reservations';
    }

    final filteredSchedules = allSchedules.where((s) {
      final from = s['from']?.toString().toLowerCase() ?? '';
      final to = s['to']?.toString().toLowerCase() ?? '';
      final departure = s['departure']?.toString().toLowerCase() ?? '';
      final query = searchController.text.toLowerCase();

      return from.contains(query) ||
          to.contains(query) ||
          departure.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: mainPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Trains Reservation",
          style: TextStyle(
            color: mainPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFD7C2F3),
              child: Icon(Icons.person_outline, color: mainPurple),
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
        child: allSchedules.isEmpty
            ? const Center(child: Text("No schedules available"))
            : Column(
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search trains, routes..',
                      prefixIcon: const Icon(Icons.search, color: mainPurple),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      pageTitle,
                      style: const TextStyle(
                        color: mainPurple,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredSchedules.isEmpty
                        ? const Center(child: Text("No matching trips found"))
                        : ListView.builder(
                            itemCount: filteredSchedules.length,
                            itemBuilder: (context, index) {
                              final s = filteredSchedules[index];

                              final from = s['from']?.toString() ?? '';
                              final to = s['to']?.toString() ?? '';
                              final departure =
                                  s['departure']?.toString() ?? '';
                              final ticket = s['ticket']?.toString() ?? '';
                              final seats = int.tryParse(
                                    s['availableSeats'].toString(),
                                  ) ??
                                  0;

                              final isFull = seats == 0;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD7C2F3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.train,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$from - $to',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(departure),
                                          const SizedBox(height: 4),
                                          Text('Price: $ticket SAR'),
                                          const SizedBox(height: 4),
                                          Text('Seats left: $seats'),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isFull
                                                  ? Colors.red.shade100
                                                  : Colors.green.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              isFull ? 'Full' : 'Available',
                                              style: TextStyle(
                                                color: isFull
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isFull &&
                                                widget.mode == 'booking'
                                            ? Colors.grey
                                            : mainPurple,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        onPressed: isFull &&
                                                widget.mode == 'booking'
                                            ? null
                                            : () async {
                                                if (widget.mode == 'booking') {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          BookingPage(
                                                        schedule: s,
                                                      ),
                                                    ),
                                                  );
                                                } else if (widget.mode ==
                                                    'cancel') {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          CancelTripPage(
                                                        schedule: s,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ViewReservationsPage(
                                                        schedule: s,
                                                      ),
                                                    ),
                                                  );
                                                }

                                                if (mounted) {
                                                  setState(() {});
                                                }
                                              },
                                      ),
                                    ),
                                  ],
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
