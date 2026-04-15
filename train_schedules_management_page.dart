import 'package:flutter/material.dart';
import 'train_management_page.dart';
import 'schedule_management_page.dart';

class TrainSchedulesManagementPage extends StatelessWidget {
  const TrainSchedulesManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF7E57C2);
    const Color lightPurple = Color(0xFFF3EEFC);
    const Color cardPurple = Color(0xFFC9B0F0);

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
          'Schedule',
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
              child: Icon(
                Icons.access_time,
                color: mainPurple,
                size: 22,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            color: mainPurple,
          ),
        ),
      ),

      // ✅ CENTERED BODY
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Schedule Management Card
              _choiceCard(
                context: context,
                title: 'Schedule Management',
                icon: Icons.edit_calendar_outlined,
                backgroundColor: cardPurple,
                iconColor: const Color(0xFF4A2A73),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ScheduleManagementPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 36),

              // Train Management Card
              _choiceCard(
                context: context,
                title: 'Train Management',
                icon: Icons.train_outlined,
                backgroundColor: cardPurple,
                iconColor: const Color(0xFF4A2A73),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const TrainManagementPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _choiceCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 50,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6A3EB5),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }}
