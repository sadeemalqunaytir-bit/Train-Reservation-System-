import 'package:flutter/material.dart';
import 'data_storage.dart';
import 'passenger_list_page.dart';

class AddPassengerPage extends StatefulWidget {
  const AddPassengerPage({super.key});

  @override
  State<AddPassengerPage> createState() => _AddPassengerPageState();
}

class _AddPassengerPageState extends State<AddPassengerPage> {

  final nameController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final tripController = TextEditingController();
  final dobController = TextEditingController();

  String gender = "Male";
  String seat = "Window";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Passenger"),
        backgroundColor: Colors.purple.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple.shade100,
              child: const Icon(Icons.person_add, size: 40, color: Colors.purple),
            ),

            const SizedBox(height: 20),

            const Text(
              "Passenger Registration",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text("Enter the passenger details below"),

            const SizedBox(height: 20),

            buildTextField("Full Name", Icons.person, controller: nameController),
            buildTextField("National ID / Passport", Icons.badge, controller: idController),
            buildTextField("Phone Number", Icons.phone, controller: phoneController),
            buildTextField("Email (Optional)", Icons.email, controller: emailController),
            buildTextField("Trip Number", Icons.confirmation_num, controller: tripController),

            DropdownButtonFormField(
              value: gender,
              decoration: inputDecoration("Gender", Icons.person),
              items: ["Male", "Female"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                gender = value!;
              },
            ),

            const SizedBox(height: 10),

            TextField(
              controller: dobController,
              decoration: inputDecoration("Date of Birth", Icons.calendar_today),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: seat,
              decoration: inputDecoration("Seat Preference", Icons.event_seat),
              items: ["Window", "Aisle", "No preference"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                seat = value!;
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {

                  int bookingId = DataStorage.bookingCounter++;

                  DataStorage.bookings.add({
                    'id': bookingId,
                    'name': nameController.text,
                    'trip': tripController.text,
                    'gender': gender,
                  });

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Booking Saved"),
                      content: Text("Booking ID: $bookingId"),
                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);

                            nameController.clear();
                            idController.clear();
                            phoneController.clear();
                            emailController.clear();
                            tripController.clear();
                            dobController.clear();
                          },
                          child: const Text("Add Another Passenger"),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PassengerListPage(),
                              ),
                            );
                          },
                          child: const Text("View Passengers"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  "Save Passenger",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, IconData icon, {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: inputDecoration(label, icon),
      ),
    );
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
