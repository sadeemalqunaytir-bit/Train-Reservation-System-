import 'package:flutter/material.dart';
import 'select_trip_page.dart';

class ReservationChoicePage extends StatelessWidget {
  const ReservationChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF6F42C1);
    const Color lightPurple = Color(0xFFF3EEFC);
    const Color iconBoxPurple = Color(0xFFB78CF2);

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: mainPurple),
          onPressed: () {},
        ),
        title: const Text(
          'Reservation',
          style: TextStyle(
            color: mainPurple,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            color: mainPurple,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              children: [
                _choiceCard(
                  title: 'Booking A Trip',
                  icon: Icons.confirmation_num_outlined,
                  mainPurple: mainPurple,
                  iconBoxPurple: iconBoxPurple,
                  onTap: () {},
                ),
                const SizedBox(height: 30),
                _choiceCard(
                  title: 'View Reservations',
                  icon: Icons.groups_outlined,
                  mainPurple: mainPurple,
                  iconBoxPurple: iconBoxPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectTripPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _choiceCard({
    required String title,
    required IconData icon,
    required Color mainPurple,
    required Color iconBoxPurple,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 78,
              decoration: BoxDecoration(
                color: mainPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Container(
                  width: 86,
                  height: 50,
                  decoration: BoxDecoration(
                    color: iconBoxPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.black87,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}