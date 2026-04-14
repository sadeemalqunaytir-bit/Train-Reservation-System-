import 'package:flutter/material.dart';
import 'data.dart';

class ViewReservationsPage extends StatefulWidget {
  final String selectedRoute;
  final String selectedTime;

  const ViewReservationsPage({
    super.key,
    required this.selectedRoute,
    required this.selectedTime,
  });

  @override
  State<ViewReservationsPage> createState() => _ViewReservationsPageState();
}

class _ViewReservationsPageState extends State<ViewReservationsPage> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredReservations = [];

  @override
  void initState() {
    super.initState();
    _loadReservations();
    searchController.addListener(_filterReservations);
  }

  void _loadReservations() {
    filteredReservations = Data.reservations.where((reservation) {
      return reservation['route'] == widget.selectedRoute &&
          reservation['time'] == widget.selectedTime;
    }).toList();
  }

  void _filterReservations() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredReservations = Data.reservations.where((reservation) {
        final sameTrip = reservation['route'] == widget.selectedRoute &&
            reservation['time'] == widget.selectedTime;

        final matchesQuery =
            reservation['ticketId']!.toLowerCase().contains(query) ||
            reservation['passengerId']!.toLowerCase().contains(query) ||
            reservation['name']!.toLowerCase().contains(query) ||
            reservation['seat']!.toLowerCase().contains(query) ||
            reservation['status']!.toLowerCase().contains(query);

        return sameTrip && matchesQuery;
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF6F42C1);
    const Color lightPurple = Color(0xFFF3EEFC);

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
          'View Reservations',
          style: TextStyle(
            color: mainPurple,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
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
                widget.selectedRoute,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.selectedTime,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: filteredReservations.isEmpty
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
                            DataColumn(label: Text('Passenger ID')),
                            DataColumn(label: Text('Passenger Name')),
                            DataColumn(label: Text('Seat Number')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: filteredReservations.map((reservation) {
                            return DataRow(
                              cells: [
                                DataCell(Text(reservation['ticketId']!)),
                                DataCell(Text(reservation['passengerId']!)),
                                DataCell(Text(reservation['name']!)),
                                DataCell(Text(reservation['seat']!)),
                                DataCell(Text(reservation['status']!)),
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