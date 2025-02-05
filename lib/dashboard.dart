import 'package:flutter/material.dart';
import 'package:events/dashboardcard.dart';
import 'package:events/eventcard.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final List<String> eventNames = ["Zennovate", "Parth", "FlutterFest"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "My Dashboard",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // My Events Section
                  const Text(
                    "My Events",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: eventNames.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 250,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: EventCard(eventName: eventNames[index]),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // My Community Section
                  const Text(
                    "My Community",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

            
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: eventNames.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 250,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: DashboardCard(eventName: eventNames[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
