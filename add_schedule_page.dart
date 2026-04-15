import 'package:flutter/material.dart';
import 'data_storage.dart';

class AddSchedulePage extends StatefulWidget {
  final Map<String, dynamic>? existingSchedule;

  const AddSchedulePage({super.key, this.existingSchedule});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final departureController = TextEditingController();
  final arrivalController = TextEditingController();

  String? selectedTrainId;
  String selectedStatus = 'Active';

  @override
  void initState() {
    super.initState();

    if (widget.existingSchedule != null) {
      selectedTrainId = widget.existingSchedule!['trainId']?.toString();
      fromController.text = widget.existingSchedule!['from']?.toString() ?? '';
      toController.text = widget.existingSchedule!['to']?.toString() ?? '';
      departureController.text =
          widget.existingSchedule!['departure']?.toString() ?? '';
      arrivalController.text =
          widget.existingSchedule!['arrival']?.toString() ?? '';
      selectedStatus = widget.existingSchedule!['status'] ?? 'Active';
    }
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    departureController.dispose();
    arrivalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trains = DataStorage.trains;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add / Edit Schedule"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedTrainId,
                decoration: const InputDecoration(
                  labelText: "Train",
                ),
                items: trains.map((train) {
                  return DropdownMenuItem<String>(
                    value: train['id'].toString(),
                    child: Text(train['name'].toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTrainId = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: fromController,
                decoration: const InputDecoration(labelText: "From"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: toController,
                decoration: const InputDecoration(labelText: "To"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: departureController,
                decoration: const InputDecoration(labelText: "Departure"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: arrivalController,
                decoration: const InputDecoration(labelText: "Arrival"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Delayed', child: Text('Delayed')),
                  DropdownMenuItem(value: 'Closed', child: Text('Closed')),
                  DropdownMenuItem(value: 'Repair', child: Text('Repair')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedTrainId == null ||
                            fromController.text.isEmpty ||
                            toController.text.isEmpty ||
                            departureController.text.isEmpty ||
                            arrivalController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields"),
                            ),
                          );
                          return;
                        }

                        final selectedTrain = trains.firstWhere(
                          (train) => train['id'].toString() == selectedTrainId,
                        );

                        final capacity =
                            int.tryParse(selectedTrain['capacity'].toString()) ?? 0;
                        final availableSeats = widget.existingSchedule != null
                            ? (int.tryParse(
                                    widget.existingSchedule!['availableSeats'].toString(),
                                  ) ??
                                  capacity)
                            : capacity;
                        final ticket =
                            double.tryParse(selectedTrain['ticket'].toString()) ?? 0;

                        Navigator.pop(context, {
                          'id': widget.existingSchedule?['id'] ??
                              'SC${DataStorage.schedules.length + 1}',
                          'trainId': selectedTrain['id'],
                          'train': selectedTrain['name'],
                          'from': fromController.text,
                          'to': toController.text,
                          'departure': departureController.text,
                          'arrival': arrivalController.text,
                          'status': selectedStatus,
                          'capacity': capacity,
                          'availableSeats': availableSeats,
                          'ticket': ticket,
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
