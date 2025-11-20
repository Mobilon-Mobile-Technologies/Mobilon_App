import 'package:eventa/widgets/border_button.dart';
import 'package:eventa/widgets/gradient_box.dart';
import 'package:eventa/widgets/gradient_line.dart';
import 'package:flutter/material.dart';
import '../models/events.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, required this.bodyStyle, required this.subStyle, required this.reserve});
  final Events event;

  final TextStyle bodyStyle;
  final TextStyle subStyle;
  final VoidCallback reserve;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GradientBox(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/FlutterImg.png",
                fit: BoxFit.cover,
                height: 144, // ✅ Fixed height
              ),
            ),
            GradLine(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: bodyStyle
                      ),
                      Text(
                        event.start_date == event.end_date
                            ? "${event.start_date} ${event.start_time.substring(0,5)} - ${event.end_time.substring(0,5)}"
                            : "${event.start_date} - ${event.end_date}",
                        style: subStyle,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BorderButton(height: 28,text: "Details", onTap: () => Navigator.pushNamed(context, '/event_details', arguments: event)),
                    BorderButton(height: 28,text: "Reserve", onTap: () => reserve()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}