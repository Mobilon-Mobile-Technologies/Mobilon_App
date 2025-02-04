import 'package:flutter/material.dart';
import 'package:events/eventcard.dart';

class EventsPage extends StatelessWidget {
  EventsPage({super.key});
  final List<String> eventNames = [
    "Zennovate",
    "Parth",
    'abc',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/Background.png"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                "Events",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: eventNames.length,
                      itemBuilder: (context, index) {
                        return EventCard(eventName: eventNames[index]);
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
