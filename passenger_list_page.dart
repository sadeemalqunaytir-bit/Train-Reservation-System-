import 'package:flutter/material.dart';
import 'data_storage.dart';

class PassengerListPage extends StatelessWidget {
  const PassengerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Passengers"),
      ),
      body: ListView.builder(
        itemCount: DataStorage.bookings.length,
        itemBuilder: (context, index) {
          final p = DataStorage.bookings[index];

          return ListTile(
            title: Text(p['name']),
            subtitle: Text("Trip: ${p['trip']}"),
            trailing: Text("ID: ${p['id']}"),
          );
        },
      ),
    );
  }
}