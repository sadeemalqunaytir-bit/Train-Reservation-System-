import 'package:flutter/material.dart';
import 'data_storage.dart';

class Book_Page extends StatefulWidget {
  const Book_Page({super.key});

  @override
  State<Book_Page> createState() => _Book_PageState();
}

class _Book_PageState extends State<Book_Page> {
  final Color mainPurple = const Color(0xFF7E57C2);
  final Color lightPurple = const Color(0xFFF8F6FB);

  final TextEditingController passengerNameController = TextEditingController();

  String? fromCity;
  String? toCity;
  String? selectedTime;
  String? selectedSeat;
  DateTime? selectedDate;

  final List<String> cities = [
    "Riyadh",
    "Hail",
    "Qassim",
    "Jeddah",
    "Khobar",
    "Dammam",
  ];

  final List<String> trainTimes = [
    "06:00 AM",
    "08:30 AM",
    "10:00 AM",
    "12:30 PM",
    "02:30 PM",
    "04:15 PM",
    "06:00 PM",
    "09:00 PM",
  ];

  List<String> getAvailableSeats() {
    final allSeats = List.generate(20, (index) => "A${index + 1}");

    final bookedSeats = DataStorage.bookings
        .where((b) => b["status"] == "Confirmed")
        .map((b) => b["seat"].toString())
        .toList();

    return allSeats.where((seat) => !bookedSeats.contains(seat)).toList();
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void addBooking() {
    if (passengerNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter passenger name")),
      );
      return;
    }

    if (fromCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select departure city")),
      );
      return;
    }

    if (toCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select destination city")),
      );
      return;
    }

    if (fromCity == toCity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("From and To cannot be the same")),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date")),
      );
      return;
    }

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select time")),
      );
      return;
    }

    if (selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select seat")),
      );
      return;
    }

    setState(() {
      DataStorage.bookings.add({
        "id": "BK${(DataStorage.bookings.length + 1).toString().padLeft(3, '0')}",
        "passengerName": passengerNameController.text.trim(),
        "route": "$fromCity → $toCity",
        "date": formatDate(selectedDate!),
        "time": selectedTime!,
        "seat": selectedSeat!,
        "status": "Confirmed",
      });

      passengerNameController.clear();
      fromCity = null;
      toCity = null;
      selectedDate = null;
      selectedTime = null;
      selectedSeat = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking added successfully")),
    );
  }

  void cancelTrip(int index) {
    final booking = DataStorage.bookings[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Cancel Booking"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Trip: ${booking["route"]}"),
              Text("Date: ${booking["date"]}"),
              Text("Time: ${booking["time"]}"),
              Text("Seat: ${booking["seat"]}"),
              const SizedBox(height: 10),
              const Text("• Are you sure you want to cancel this booking?"),
              const Text("• The booking will be marked as Cancelled ⚠️"),
              const Text("• This action cannot be undone ⚠️"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: mainPurple),
              onPressed: () {
                setState(() {
                  booking["status"] = "Cancelled";
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Booking cancelled")),
                );
              },
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

  Widget dropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableSeats = getAvailableSeats();

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Book", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Book Your Trip",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passengerNameController,
              decoration: InputDecoration(
                labelText: "Passenger Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            dropdown("From", fromCity, cities, (value) {
              setState(() {
                fromCity = value;
              });
            }),

            const SizedBox(height: 12),

            dropdown("To", toCity, cities, (value) {
              setState(() {
                toCity = value;
              });
            }),

            const SizedBox(height: 12),

            InkWell(
              onTap: pickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  selectedDate == null
                      ? "Select Date"
                      : "Date: ${formatDate(selectedDate!)}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            dropdown("Time", selectedTime, trainTimes, (value) {
              setState(() {
                selectedTime = value;
              });
            }),

            const SizedBox(height: 12),

            dropdown("Seat", selectedSeat, availableSeats, (value) {
              setState(() {
                selectedSeat = value;
              });
            }),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: addBooking,
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Bookings",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            DataStorage.bookings.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No bookings yet"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: DataStorage.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = DataStorage.bookings[index];
                      final isCancelled = booking["status"] == "Cancelled";

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isCancelled
                                ? Icons.cancel
                                : Icons.confirmation_num,
                            color: isCancelled ? Colors.red : mainPurple,
                          ),
                          title: Text(booking["passengerName"].toString()),
                          subtitle: Text(
                            "Booking ID: ${booking["id"]}\n"
                            "Trip: ${booking["route"]}\n"
                            "Date: ${booking["date"]} - ${booking["time"]}\n"
                            "Seat: ${booking["seat"]}",
                          ),
                          trailing: isCancelled
                              ? const Text(
                                  "Cancelled",
                                  style: TextStyle(color: Colors.red),
                                )
                              : OutlinedButton(
                                  onPressed: () => cancelTrip(index),
                                  child: const Text("Cancel"),
                                ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}