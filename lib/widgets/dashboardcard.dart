import 'package:admin_page/widgets/border_button.dart';
import 'package:admin_page/widgets/gradient_box.dart';
import 'package:admin_page/widgets/gradient_line.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.eventName, required this.bodyStyle, required this.subStyle});
  final String eventName;

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
                        eventName,
                        style: bodyStyle
                      ),
                      Text(
                        "12 Aug",
                        style: subStyle,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BorderButton(height: screenSize.width*0.075,text: "Details", onTap: () => print("a")),
                    BorderButton(height: screenSize.width*0.075,text: "Reserve", onTap: () => print("b")),
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
