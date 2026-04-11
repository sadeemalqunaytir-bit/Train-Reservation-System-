import 'package:flutter/material.dart';

class AddPassengerPage extends StatelessWidget {
  const AddPassengerPage({super.key});

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

            buildTextField("Full Name", Icons.person),
            buildTextField("National ID / Passport", Icons.badge),
            buildTextField("Phone Number", Icons.phone),
            buildTextField("Email (Optional)", Icons.email),

            const SizedBox(height: 10),


            DropdownButtonFormField(
              decoration: inputDecoration("Gender", Icons.person),
              items: ["Male", "Female"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),

            const SizedBox(height: 10),


            TextField(
              decoration: inputDecoration("Date of Birth", Icons.calendar_today),
            ),

            const SizedBox(height: 10),


            DropdownButtonFormField(
              decoration: inputDecoration("Seat Preference", Icons.event_seat),
              items: ["Window", "Aisle", "No preference"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('The passenger was successfully registered.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text("Save Passenger"),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildTextField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
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