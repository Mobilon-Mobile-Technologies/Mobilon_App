import 'package:eventa/widgets/border_button.dart';
import 'package:eventa/widgets/gradient_box.dart';
import 'package:eventa/widgets/gradient_line.dart';
import 'package:flutter/material.dart';
import '../models/events.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.navigatorToReserveQR, required this.event, required this.navigatorToQR, required this.bodyStyle, required this.subStyle});
  final Events event;
  final VoidCallback navigatorToReserveQR;
  final VoidCallback navigatorToQR;
  final TextStyle bodyStyle;
  final TextStyle subStyle;

  
  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GradientBox(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/FlutterImg.png",
                fit: BoxFit.cover,
                height: 144, 
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
                            ? "${event.start_time} - ${event.end_time}"
                            : "${event.start_date} - ${event.end_date}",
                        style: subStyle,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BorderButton(height: screenSize.width*0.075,text: "Details", onTap: navigatorToReserveQR),
                    BorderButton(height: screenSize.width*0.075,text: "Get QR", onTap: navigatorToQR),
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
