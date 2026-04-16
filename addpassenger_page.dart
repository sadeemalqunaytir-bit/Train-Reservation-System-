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

  String gender = "Male";
 

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  final List<String> days = List.generate(31, (index) => '${index + 1}');
  final List<String> months = List.generate(12, (index) => '${index + 1}');
  final List<String> years = List.generate(70, (index) => '${2025 - index}');

  @override
  void initState() {
    super.initState();

    if (widget.existingPassenger != null) {
      final passenger = widget.existingPassenger!;

      nameController.text = passenger['name']?.toString() ?? '';
      idController.text = passenger['id']?.toString() ?? '';
      phoneController.text = passenger['phone']?.toString() ?? '';
      emailController.text = passenger['email']?.toString() ?? '';
      gender = passenger['gender']?.toString() ?? 'Male';
     

      final dob = passenger['dob']?.toString() ?? '';
      if (dob.contains('/')) {
        final parts = dob.split('/');
        if (parts.length == 3) {
          selectedDay = parts[0];
          selectedMonth = parts[1];
          selectedYear = parts[2];
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _savePassenger() {
    final name = nameController.text.trim();
    final id = idController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || id.isEmpty || phone.isEmpty) {
      _showError("Please fill required fields");
      return;
    }

    if (RegExp(r'[0-9]').hasMatch(name)) {
      _showError("Name must not contain numbers");
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(id)) {
      _showError("ID must contain numbers only");
      return;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      _showError("Phone number must be exactly 10 digits");
      return;
    }

    if (selectedDay == null || selectedMonth == null || selectedYear == null) {
      _showError("Please select date of birth");
      return;
    }

    final isEdit =
        widget.existingPassenger != null && widget.passengerIndex != null;

    final exists = DataStorage.passengers.any(
      (p) =>
          p['id'] == id &&
          (!isEdit || DataStorage.passengers.indexOf(p) != widget.passengerIndex),
    );

    if (exists) {
      _showError("Passenger already registered with this ID");
      return;
    }

    final dob = '$selectedDay/$selectedMonth/$selectedYear';

    final passengerData = {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'gender': gender,
      'dob': dob,
     
    };

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
              ? "Passenger updated successfully"
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

                setState(() {
                  gender = "Male";
                
                  selectedDay = null;
                  selectedMonth = null;
                  selectedYear = null;
                });
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(isEdit ? "Back" : "Add Another"),
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

  Widget buildTextField(
    String label,
    IconData icon, {
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildDropdownBox({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
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

            buildTextField(
              "Full Name",
              Icons.person,
              controller: nameController,
            ),
            buildTextField(
              "National ID",
              Icons.badge,
              controller: idController,
            ),
            buildTextField(
              "Phone Number",
              Icons.phone,
              controller: phoneController,
            ),
            buildTextField(
              "Email",
              Icons.email,
              controller: emailController,
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(
                labelText: "Gender",
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male"),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Icon(Icons.calendar_today, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "Date of Birth",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                buildDropdownBox(
                  hint: "Day",
                  value: selectedDay,
                  items: days,
                  onChanged: (value) {
                    setState(() {
                      selectedDay = value;
                    });
                  },
                ),
                buildDropdownBox(
                  hint: "Month",
                  value: selectedMonth,
                  items: months,
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value;
                    });
                  },
                ),
                buildDropdownBox(
                  hint: "Year",
                  value: selectedYear,
                  items: years,
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),


            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _savePassenger,
              child: Text(isEdit ? "Update" : "Save"),
            ),
          ],
        ),
      ),
    );
  }
}
