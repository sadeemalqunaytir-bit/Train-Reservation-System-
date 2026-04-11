import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSchedulePage extends StatefulWidget {
  final Map<String, dynamic>? existingSchedule;

  const AddSchedulePage({super.key, this.existingSchedule});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final trainController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final departureController = TextEditingController();
  final arrivalController = TextEditingController();

  String departurePeriod = 'AM';
  String arrivalPeriod = 'AM';
  String selectedStatus = 'Active';

  @override
  void initState() {
    super.initState();

    if (widget.existingSchedule != null) {
      trainController.text = widget.existingSchedule!['train'] ?? '';
      fromController.text = widget.existingSchedule!['from'] ?? '';
      toController.text = widget.existingSchedule!['to'] ?? '';

      // Split time and period if editing
      final dep = widget.existingSchedule!['departure'] ?? '';
      final arr = widget.existingSchedule!['arrival'] ?? '';

      if (dep.contains(' ')) {
        departureController.text = dep.split(' ')[0];
        departurePeriod = dep.split(' ')[1];
      }

      if (arr.contains(' ')) {
        arrivalController.text = arr.split(' ')[0];
        arrivalPeriod = arr.split(' ')[1];
      }

      selectedStatus = widget.existingSchedule!['status'] ?? 'Active';
    }
  }

  @override
  void dispose() {
    trainController.dispose();
    fromController.dispose();
    toController.dispose();
    departureController.dispose();
    arrivalController.dispose();
    super.dispose();
  }

  Widget _timeField({
    required TextEditingController controller,
    required String label,
    required String period,
    required Function(String?) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d{0,2}:?\d{0,2}$'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: period,
          items: const [
            DropdownMenuItem(value: 'AM', child: Text('AM')),
            DropdownMenuItem(value: 'PM', child: Text('PM')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add / Edit Schedule")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: trainController,
                decoration: const InputDecoration(labelText: "Train ID"),
              ),

              TextField(
                controller: fromController,
                decoration: const InputDecoration(labelText: "From"),
              ),

              TextField(
                controller: toController,
                decoration: const InputDecoration(labelText: "To"),
              ),

              const SizedBox(height: 10),

              // Departure Time + AM/PM
              _timeField(
                controller: departureController,
                label: "Departure Time (H:M)",
                period: departurePeriod,
                onChanged: (v) {
                  if (v != null) {
                    setState(() => departurePeriod = v);
                  }
                },
              ),

              const SizedBox(height: 10),

              // Arrival Time + AM/PM
              _timeField(
                controller: arrivalController,
                label: "Arrival Time (H:M)",
                period: arrivalPeriod,
                onChanged: (v) {
                  if (v != null) {
                    setState(() => arrivalPeriod = v);
                  }
                },
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Delayed', child: Text('Delayed')),
                  DropdownMenuItem(value: 'Canceled', child: Text('Canceled')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => selectedStatus = v);
                  }
                },
              ),

              const SizedBox(height: 20),

              Row(
  children: [
    //  Cancel Button
    Expanded(
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context); // go back without saving
        },
        child: const Text("Cancel"),
      ),
    ),

    const SizedBox(width: 10),

    //  Save Button
    Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (trainController.text.isEmpty ||
              fromController.text.isEmpty ||
              toController.text.isEmpty ||
              departureController.text.isEmpty ||
              arrivalController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Fill all fields")),
            );
            return;
          }

          final departure =
              "${departureController.text} $departurePeriod";
          final arrival =
              "${arrivalController.text} $arrivalPeriod";

          Navigator.pop(context, {
            'train': trainController.text,
            'from': fromController.text,
            'to': toController.text,
            'departure': departure,
            'arrival': arrival,
            'status': selectedStatus,
          });
        },
        child: const Text("Save"),
      ),
    ),
  ],
),
            ],
          ),
        ),
      ),
    );
  }
}
