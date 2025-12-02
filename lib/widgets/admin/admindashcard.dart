import 'package:eventa/models/events.dart';
import 'package:eventa/widgets/border_button.dart';
import 'package:eventa/widgets/gradient_box.dart';
import 'package:eventa/widgets/gradient_line.dart';
import 'package:flutter/material.dart';

class Admindashcard extends StatelessWidget {
  const Admindashcard(
      {super.key,
      required this.event,
      required this.bodyStyle,
      required this.subStyle,
      required this.edit,
      required this.reserve,
      required this.showQr});
  final Events event;
  final VoidCallback edit;
  final VoidCallback reserve;
  final VoidCallback showQr;
  final TextStyle bodyStyle;
  final TextStyle subStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GradientBox(
        child: Column(
          children: [
            if (event.team_size>1) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Requires team of ${event.team_size} to enter!",style: bodyStyle.copyWith(color: Colors.white),),
                  GradLine()
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/crowd_img_1.jpg",
                fit: BoxFit.cover,
                height: 160, // ✅ Fixed height
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
                            ? "On ${event.start_date} \n${event.start_time.substring(0,5)} to ${event.end_time.substring(0,5)}"
                            : "${event.start_date} \nto ${event.end_date}",
                        style: subStyle,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BorderButton(
                        height: 28,
                        text: "Edit",
                        onTap: edit,
                      ),
                    BorderButton(
                        height: 28,
                        text: "Reserve",
                        onTap: reserve,
                      ),
                    BorderButton(
                      height: 28,
                      text: "Show QR", 
                      onTap: showQr)
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
