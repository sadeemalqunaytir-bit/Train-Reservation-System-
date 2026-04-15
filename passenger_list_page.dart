import 'package:flutter/material.dart';
import 'data_storage.dart';
import 'addpassenger_page.dart';

class PassengerListPage extends StatefulWidget {
  const PassengerListPage({super.key});

  @override
  State<PassengerListPage> createState() => _PassengerListPageState();
}

class _PassengerListPageState extends State<PassengerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Passengers"),
      ),
      body: DataStorage.passengers.isEmpty
          ? const Center(
              child: Text("No passengers found"),
            )
          : ListView.builder(
              itemCount: DataStorage.passengers.length,
              itemBuilder: (context, index) {
                final p = DataStorage.passengers[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(p['name']?.toString() ?? ''),
                    subtitle: Text("Trip: ${p['trip']?.toString() ?? ''}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("ID: ${p['id']?.toString() ?? ''}"),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.purple),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPassengerPage(
                                  existingPassenger: p,
                                  passengerIndex: index,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
