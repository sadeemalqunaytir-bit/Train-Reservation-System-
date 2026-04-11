import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTrainPage extends StatefulWidget {
  final Map<String, dynamic>? existingTrain;

  const AddTrainPage({super.key, this.existingTrain});

  @override
  State<AddTrainPage> createState() => _AddTrainPageState();
}

class _AddTrainPageState extends State<AddTrainPage> {
  final trainIdController = TextEditingController();
  final nameController = TextEditingController();
  final capacityController = TextEditingController();
  final ticketController = TextEditingController();

  String selectedStatus = 'Active';
  String selectedCategory = 'Passenger';

  final List<String> categories = [
    'Passenger',
    'Express',
    'High-Speed',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.existingTrain != null) {
      trainIdController.text = widget.existingTrain!['id'] ?? '';
      nameController.text = widget.existingTrain!['name'] ?? '';
      capacityController.text = widget.existingTrain!['capacity'] ?? '';
      ticketController.text =
          (widget.existingTrain!['ticket'] ?? '').toString().replaceAll(' SAR', '');

      selectedStatus = widget.existingTrain!['status'] ?? 'Active';
      selectedCategory = widget.existingTrain!['category'] ?? 'Passenger';
    }
  }

  @override
  void dispose() {
    trainIdController.dispose();
    nameController.dispose();
    capacityController.dispose();
    ticketController.dispose();
    super.dispose();
  }

  String _formatTicket(String value) {
    final number = double.parse(value);

    if (number == number.toInt()) {
      return '${number.toInt()} SAR';
    }

    return '${number.toStringAsFixed(2)} SAR';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add / Edit Train")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Train ID
              TextField(
                controller: trainIdController,
                decoration: const InputDecoration(
                  labelText: "Train ID",
                ),
              ),

              // Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),

              // Train Category (Dropdown)
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Train Category",
                ),
                items: categories.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedCategory = value);
                  }
                },
              ),

              const SizedBox(height: 10),

              // Capacity
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(
                  labelText: "Capacity",
                  suffixText: "Seats",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 10),

              // Ticket Price
              TextField(
                controller: ticketController,
                decoration: const InputDecoration(
                  labelText: "Ticket Price",
                  suffixText: "SAR",
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}$'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Status
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Status",
                ),
                items: const [
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Delayed', child: Text('Delayed')),
                  DropdownMenuItem(value: 'Closed', child: Text('Closed')),
                  DropdownMenuItem(value: 'Repair', child: Text('Repair')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedStatus = value);
                  }
                },
              ),

              const SizedBox(height: 20),

              // Save Button
              Row(
  children: [
    Expanded( // Cancel Button
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context); // go back without saving
        },
        child: const Text("Cancel"),
      ),
    ),

    const SizedBox(width: 10),

                  
                  Expanded( // Save Button
                    child: ElevatedButton(
                      onPressed: () {
                        if (trainIdController.text.isEmpty ||
                            nameController.text.isEmpty ||
                            capacityController.text.isEmpty ||
                            ticketController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields"),
                            ),
                          );
                          return;
                        }

                        final ticketValue = double.tryParse(
                          ticketController.text,
                        );

                        if (ticketValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid ticket price"),
                            ),
                          );
                          return;
                        }

                        final formattedTicket = _formatTicket(
                          ticketController.text,
                        );

                        Navigator.pop(context, {
                          'id': trainIdController.text,
                          'name': nameController.text,
                          'category': selectedCategory,
                          'capacity': capacityController.text,
                          'ticket': formattedTicket,
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
