import 'package:flutter/material.dart';
import 'addpassenger_page.dart';
import 'train_schedules_management_page.dart';
import 'reservation_choice_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'data_storage.dart';

class HomePage extends StatefulWidget {
  final String role;

  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Train Reservation'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              Text(
                widget.role == "admin"
                    ? 'Welcome back, Admin!'
                    : 'Welcome back, Staff!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Where would you like to do today?',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 25),


              if (widget.role == "admin") ...[
                const Text(
                  "System Statistics",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),

                const SizedBox(height: 15),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _statCard("Trains", DataStorage.trains.length, Icons.train),
                    _statCard("Schedules", DataStorage.schedules.length, Icons.schedule),
                    _statCard("Bookings", DataStorage.bookings.length, Icons.confirmation_num),
                    _statCard("Passengers", DataStorage.passengers.length, Icons.people),
                    _statCard("Seats", _calculateTotalSeats(), Icons.event_seat),
                  ],
                ),
              ],

              const SizedBox(height: 30),

              const Text(
                'Quick Access',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  if (widget.role == "staff")
                    _quickAccessItem(
                      icon: Icons.people,
                      label: 'Passengers',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPassengerPage(),
                          ),
                        );
                        refresh();
                      },
                    ),

                const SizedBox(width: 20),
                  if (widget.role == "admin")
                    _quickAccessItem(
                      icon: Icons.schedule,
                      label: 'Schedules',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const TrainSchedulesManagementPage(),
                          ),
                        );
                        refresh();
                      },
                    ),

                  if (widget.role == "staff")
                    _quickAccessItem(
                      icon: Icons.confirmation_num,
                      label: 'Reservations',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const ReservationChoicePage(),
                          ),
                        );
                        refresh();
                      },
                    ),
                ],
              ),

              const SizedBox(height: 30),


              if (widget.role == "staff") ...[
                const Text(
                  'Recent Trips Booked',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                Column(
                  children: [
                    _tripItem(
                      route: 'Riyadh -> Qassim',
                      status: 'Confirmed',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    _tripItem(
                      route: 'Dammam -> Riyadh',
                      status: 'Pending',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),


      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(icon: Icons.home, label: 'Home'),

            _bottomNavItem(
              icon: Icons.search,
              label: 'Search',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),

            if (widget.role == "admin")
              _bottomNavItem(
                icon: Icons.confirmation_num,
                label: 'Bookings',
              ),

            _bottomNavItem(
              icon: Icons.person,
              label: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, int value, IconData icon) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculateTotalSeats() {
    int total = 0;
    for (var s in DataStorage.schedules) {
      total += int.tryParse(s['availableSeats'].toString()) ?? 0;
    }
    return total;
  }

  Widget _quickAccessItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.purple),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _tripItem({
    required String route,
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.train, color: Colors.purple, size: 30),
              const SizedBox(width: 10),
              Text(route),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}
