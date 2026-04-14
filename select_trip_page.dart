import 'package:flutter/material.dart';
import 'data.dart';
import 'view_reservation_page.dart';

class SelectTripPage extends StatelessWidget {
  const SelectTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF6F42C1);
    const Color lightPurple = Color(0xFFF3EEFC);

    final trips = Data.trips;

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        title: const Text(
          'Trains Reservation',
          style: TextStyle(
            color: mainPurple,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFD7C2F3),
              child: Icon(Icons.person_outline, color: mainPurple),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Divider(height: 2, thickness: 2, color: mainPurple),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

           
            TextField(
              decoration: InputDecoration(
                hintText: 'Search trains,routes..',
                prefixIcon: const Icon(Icons.search, color: mainPurple),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Trip',
                style: TextStyle(
                  color: mainPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

           
            Expanded(
              child: ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Row(
                      children: [

                        
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7C2F3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.train, color: Colors.black87),
                        ),

                        const SizedBox(width: 12),

                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip['route']!,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trip['time']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        
                        Container(
                          width: 90,
                          height: 42,
                          decoration: BoxDecoration(
                            color: mainPurple,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                            
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewReservationsPage(
                                    selectedRoute: trip['route']!,
                                    selectedTime: trip['time']!,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}