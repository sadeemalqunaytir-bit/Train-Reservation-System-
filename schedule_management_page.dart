import 'package:flutter/material.dart';
import 'add_schedule_page.dart';
import 'data_storage.dart';

class ScheduleManagementPage extends StatefulWidget {
  const ScheduleManagementPage({super.key});

  @override
  State<ScheduleManagementPage> createState() => _ScheduleManagementPageState();
}

class _ScheduleManagementPageState extends State<ScheduleManagementPage> {
  final List<Map<String, dynamic>> schedules = DataStorage.schedules;

  void _addSchedule(Map<String, dynamic> schedule) {
    setState(() {
      schedules.add(schedule);
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF7E57C2);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Management"),
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
                    builder: (context) => const AddSchedulePage(),
                  ),
                );

                if (result != null) {
                  _addSchedule(result);
                }
              },
              child: const Text("+ Add Schedule"),
            ),

            const SizedBox(height: 20),

            Expanded(
  child: schedules.isEmpty
      ? const Center(child: Text("No schedules yet"))
      : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 20,
              horizontalMargin: 12,
              columns: const [
                DataColumn(label: Text("Train")),
                DataColumn(label: Text("From")),
                DataColumn(label: Text("To")),
                DataColumn(label: Text("Departure")),
                DataColumn(label: Text("Arrival")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Action")),
              ],
              rows: List.generate(schedules.length, (index) {
                final s = schedules[index];

                return DataRow(cells: [
                  DataCell(Text(s['train'])),
                  DataCell(Text(s['from'])),
                  DataCell(Text(s['to'])),
                  DataCell(Text(s['departure'])),
                  DataCell(Text(s['arrival'])),
                  DataCell(Text(s['status'])),

                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.purple),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddSchedulePage(existingSchedule: s),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                schedules[index] = result;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              schedules.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }),
            ),
          ),
        ),
)
          ],
        ),
      ),
    );
  }
}
