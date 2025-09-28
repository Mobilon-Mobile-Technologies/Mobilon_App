import 'package:admin_page/models/events.dart';
import 'package:admin_page/widgets/border_button.dart';
import 'package:admin_page/widgets/gradient_box.dart';
import 'package:admin_page/widgets/gradient_line.dart';
import 'package:flutter/material.dart';

class Admindashcard extends StatelessWidget {
  const Admindashcard(
      {super.key,
      required this.event,
      required this.bodyStyle,
      required this.subStyle,
      required this.edit});
  final Events event;
  final VoidCallback edit;
  final TextStyle bodyStyle;
  final TextStyle subStyle;

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
                      Text(event.name, style: bodyStyle),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BorderButton(
                        height: 28,
                        text: "Edit Event",
                        onTap: edit,
                      ),
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
