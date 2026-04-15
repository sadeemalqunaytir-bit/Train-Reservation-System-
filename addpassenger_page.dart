import 'package:flutter/material.dart';
import 'data_storage.dart';
import 'passenger_list_page.dart';

class AddPassengerPage extends StatefulWidget {
  final Map<String, dynamic>? existingPassenger;
  final int? passengerIndex;

  const AddPassengerPage({
    super.key,
    this.existingPassenger,
    this.passengerIndex,
  });

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
  void initState() {
    super.initState();

    if (widget.existingPassenger != null) {
      nameController.text = widget.existingPassenger!['name']?.toString() ?? '';
      idController.text = widget.existingPassenger!['id']?.toString() ?? '';
      phoneController.text =
          widget.existingPassenger!['phone']?.toString() ?? '';
      emailController.text =
          widget.existingPassenger!['email']?.toString() ?? '';
      tripController.text =
          widget.existingPassenger!['trip']?.toString() ?? '';
      dobController.text = widget.existingPassenger!['dob']?.toString() ?? '';
      gender = widget.existingPassenger!['gender']?.toString() ?? 'Male';
      seat = widget.existingPassenger!['seat']?.toString() ?? 'Window';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    phoneController.dispose();
    emailController.dispose();
    tripController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void _savePassenger() {
    if (nameController.text.trim().isEmpty ||
        idController.text.trim().isEmpty ||
        tripController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill required fields"),
        ),
      );
      return;
    }

    final passengerData = {
      'id': idController.text.trim(),
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'trip': tripController.text.trim(),
      'gender': gender,
      'dob': dobController.text.trim(),
      'seat': seat,
    };

    final isEdit =
        widget.existingPassenger != null && widget.passengerIndex != null;

    if (isEdit) {
      DataStorage.passengers[widget.passengerIndex!] = passengerData;
    } else {
      DataStorage.passengers.add(passengerData);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Passenger Updated" : "Passenger Saved"),
        content: Text(
          isEdit
              ? "Passenger information updated successfully"
              : "Passenger saved successfully",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              if (!isEdit) {
                nameController.clear();
                idController.clear();
                phoneController.clear();
                emailController.clear();
                tripController.clear();
                dobController.clear();

                setState(() {
                  gender = "Male";
                  seat = "Window";
                });
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(isEdit ? "Back" : "Add Another Passenger"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
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
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingPassenger != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Passenger" : "Add Passenger"),
        backgroundColor: Colors.purple.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple.shade100,
              child: Icon(
                isEdit ? Icons.edit : Icons.person_add,
                size: 40,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isEdit ? "Edit Passenger Information" : "Passenger Registration",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Enter the passenger details below"),
            const SizedBox(height: 20),

            buildTextField("Full Name", Icons.person, controller: nameController),
            buildTextField(
              "National ID / Passport",
              Icons.badge,
              controller: idController,
            ),
            buildTextField(
              "Phone Number",
              Icons.phone,
              controller: phoneController,
            ),
            buildTextField(
              "Email (Optional)",
              Icons.email,
              controller: emailController,
            ),
            buildTextField(
              "Trip Number",
              Icons.confirmation_num,
              controller: tripController,
            ),

            DropdownButtonFormField<String>(
              value: gender,
              decoration: inputDecoration("Gender", Icons.person),
              items: ["Male", "Female"]
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            TextField(
              controller: dobController,
              decoration: inputDecoration(
                "Date of Birth",
                Icons.calendar_today,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: seat,
              decoration: inputDecoration("Seat Preference", Icons.event_seat),
              items: ["Window", "Aisle", "No preference"]
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  seat = value!;
                });
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
                onPressed: _savePassenger,
                child: Text(
                  isEdit ? "Update Passenger" : "Save Passenger",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    IconData icon, {
    TextEditingController? controller,
  }) {
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
