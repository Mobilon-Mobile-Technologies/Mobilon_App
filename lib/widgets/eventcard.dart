import 'package:admin_page/models/events.dart';
import 'package:admin_page/screens/qr_page.dart';
import 'package:admin_page/widgets/border_button.dart';
import 'package:admin_page/widgets/dashboardcard.dart';
import 'package:admin_page/widgets/gradient_box.dart';
import 'package:admin_page/widgets/gradient_line.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard(
      {super.key,
      required this.event,
      required this.bodyStyle,
      required this.subStyle,
      required this.reserve});
  final Events event;

  final TextStyle bodyStyle;
  final TextStyle subStyle;
  final VoidCallback reserve;

  void showDetailsDialog(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: screenSize.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Close button
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Main content
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Event Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.5),
                                Colors.transparent,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          event.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        EventInfoRow(
                          icon: Icons.calendar_today,
                          label: "Date",
                          value: "${event.start_date} - ${event.end_date}",
                        ),
                        EventInfoRow(
                          icon: Icons.access_time,
                          label: "Time",
                          value: "${event.start_time} - ${event.end_time}",
                        ),
                        EventInfoRow(
                          icon: Icons.location_on,
                          label: "Location",
                          value: event.location,
                        ),
                        EventInfoRow(
                          icon: Icons.people,
                          label: "Capacity",
                          value: event.capacity,
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                event.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GradientBox(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Show the image in a dialog when tapped
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Image.asset(
                        "assets/mobile_next.jpeg", // Your image path
                        fit: BoxFit.fitWidth,
                        width: screenSize.width * 0.9,
                        height: screenSize.height * 0.5,
                      ),
                    );
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/mobile_next.jpeg",
                  fit: BoxFit.fill,
                  height: screenSize.height * 0.2,
                  width: screenSize.width * 0.8,
                ),
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
                      Text(event.name, style: bodyStyle),
                      Text(
                        event.start_date,
                        style: subStyle,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BorderButton(
                        height: 28,
                        text: "Details",
                        onTap: () => showDetailsDialog(context)),
                    BorderButton(
                        height: 28,
                        text: "Get QR",
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QRPage(event: event),
                            ))),
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
