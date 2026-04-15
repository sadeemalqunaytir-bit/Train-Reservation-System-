import 'package:flutter/material.dart';
import 'select_trip_page.dart';

class ReservationChoicePage extends StatelessWidget {
  const ReservationChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF7E57C2);
    const Color lightPurple = Color(0xFFF3EEFC);
    const Color cardWhite = Color(0xFFFDFDFD);
    const Color iconBoxPurple = Color(0xFFB78CF2);

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: mainPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reservation',
          style: TextStyle(
            color: mainPurple,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: mainPurple),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            child: Column(
              children: [
                const SizedBox(height: 18),

                _reservationCard(
                  title: 'Booking A Trip',
                  icon: Icons.confirmation_num_outlined,
                  mainPurple: mainPurple,
                  iconBoxPurple: iconBoxPurple,
                  cardWhite: cardWhite,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectTripPage(mode: 'booking'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                _reservationCard(
                  title: 'Cancel Trip',
                  icon: Icons.cancel_outlined,
                  mainPurple: mainPurple,
                  iconBoxPurple: iconBoxPurple,
                  cardWhite: cardWhite,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectTripPage(mode: 'cancel'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                _reservationCard(
                  title: 'View Reservations',
                  icon: Icons.groups_outlined,
                  mainPurple: mainPurple,
                  iconBoxPurple: iconBoxPurple,
                  cardWhite: cardWhite,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectTripPage(mode: 'view'),
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

  Widget _reservationCard({
    required String title,
    required IconData icon,
    required Color mainPurple,
    required Color iconBoxPurple,
    required Color cardWhite,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 72,
              decoration: BoxDecoration(
                color: mainPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Container(
                  width: 84,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBoxPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF3D235E),
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3D235E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
