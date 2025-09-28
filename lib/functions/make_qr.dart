import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/events.dart';

String formatDateTime(String date, String time) {
  return '${date.replaceAll('-', '')}T${time.replaceAll(':', '')}';
}

// String genQrData(Events event) {
//   return """
// BEGIN:VCALENDAR
// BEGIN:VEVENT
// DESCRIPTION:${event.description}
// DTEND;TZID=Asia/Kolkata:${formatDateTime(event.end_date, event.end_time)}
// DTSTART;TZID=Asia/Kolkata:${formatDateTime(event.start_date, event.start_time)}
// SEQUENCE:0
// SUMMARY:${event.name}
// TRANSP:OPAQUE
// UID:${event.events_id}
// LOCATION:${event.location}
// END:VEVENT
// END:VCALENDAR
// """;
// }

// Widget genQr(Events event, double size) {
//   return QrImageView(
//     data: genQrData(event),
//     version: QrVersions.auto,
//     size: size,
//   );
// }

// Generate data for check-in QR code
String genCheckinQrData(Events event) {
  return 'myapp://checkin?event_id=${event.events_id}&name=${Uri.encodeComponent(event.name)}';
}

// Generate check-in QR widget
Widget genQr(Events event, double size) {
  return QrImageView(
    data: genCheckinQrData(event),
    version: QrVersions.auto,
    size: size,
  );
}

// Generate data for reservation QR code
String genReserveQrData(Events event) {
  return 'myapp://reserve?event_id=${event.events_id}&name=${Uri.encodeComponent(event.name)}';
}

// Generate reservation QR widget
Widget genReserveQr(Events event, double size) {
  return QrImageView(
    data: genReserveQrData(event),
    version: QrVersions.auto,
    size: size,
  );
}