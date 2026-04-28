import 'package:flutter/material.dart';
import 'data_storage.dart';

class Reports_Page extends StatelessWidget {
  const Reports_Page({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = DataStorage.bookings;
    final confirmed =
        bookings.where((b) => b["status"] == "Confirmed").length;
    final cancelled =
        bookings.where((b) => b["status"] == "Cancelled").length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Colors.deepPurple),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                "Booking Reports",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Overview of all bookings in the system",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statCard("Total Bookings", bookings.length.toString(),
                      Icons.grid_view),
                  statCard(
                      "Confirmed", confirmed.toString(), Icons.check_circle),
                  statCard("Cancelled", cancelled.toString(), Icons.cancel),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search bookings...",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.filter_list),
                  )
                ],
              ),

              const SizedBox(height: 16),

              Expanded(
                child: bookings.isEmpty
                    ? const Center(child: Text("No bookings yet"))
                    : ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final b = bookings[index];
                          final isConfirmed = b["status"] == "Confirmed";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      b["passengerName"] ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isConfirmed
                                            ? Colors.green.shade100
                                            : Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        b["status"] ?? "",
                                        style: TextStyle(
                                          color: isConfirmed
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(b["route"] ?? ""),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 14),
                                    const SizedBox(width: 4),
                                    Text("${b["date"]} - ${b["time"]}"),
                                    const Spacer(),
                                    const Icon(Icons.event_seat, size: 14),
                                    const SizedBox(width: 4),
                                    Text(b["seat"] ?? ""),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              Text("Showing ${bookings.length} bookings"),
            ],
          ),
        ),
      ),
    );
  }

  Widget statCard(String title, String number, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            number,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      ),
    );
  }
}