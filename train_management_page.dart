import 'package:flutter/material.dart';
import 'add_train_page.dart';
import 'data_storage.dart';

class TrainManagementPage extends StatefulWidget {
  const TrainManagementPage({super.key});

  @override
  State<TrainManagementPage> createState() => _TrainManagementPageState();
}

class _TrainManagementPageState extends State<TrainManagementPage> {
  final trains = DataStorage.trains;

  void _addTrain(Map<String, dynamic> train) {
    setState(() => trains.add(train));
  }

  void _editTrain(int index, Map<String, dynamic> updated) {
    setState(() => trains[index] = updated);
  }

  void _deleteTrain(int index) {
    setState(() => trains.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    const mainPurple = Color(0xFF7E57C2);
    const lightPurple = Color(0xFFF3EEFC);

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        title: const Text("Train Management"),
        backgroundColor: mainPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTrainPage(),
                  ),
                );

                if (result != null) {
                  _addTrain(result);
                }
              },
              child: const Text("+ Add Train"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: trains.isEmpty
                  ? const Center(child: Text("No trains added yet"))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 20,
                          horizontalMargin: 12,
                          columns: const [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Category")),
                            DataColumn(label: Text("Seats")),
                            DataColumn(label: Text("Ticket")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Action")),
                          ],
                          rows: List.generate(trains.length, (index) {
                            final t = trains[index];

                            return DataRow(
                              cells: [
                                DataCell(Text((t['id'] ?? '').toString())),
                                DataCell(Text((t['name'] ?? '').toString())),
                                DataCell(Text((t['category'] ?? '').toString())),
                                DataCell(
                                  Text(
                                    "${t['availableSeats'] ?? t['capacity']}/${t['capacity'] ?? 0}",
                                  ),
                                ),
                                DataCell(Text((t['ticket'] ?? '').toString())),
                                DataCell(Text((t['status'] ?? '').toString())),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.purple,
                                        ),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddTrainPage(existingTrain: t),
                                            ),
                                          );

                                          if (result != null) {
                                            _editTrain(index, result);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _deleteTrain(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
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
