import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:admin_page/models/events.dart';

final supabase = Supabase.instance.client;

Future<List<Events>> getEvents() async {

  if (supabase.auth.currentUser == null) {
    return [];
  }

  final list = await supabase
      .from('events')
      .select('*');
  
  print('Fetched data: $list'); // Debug print
  
  if (list.isNotEmpty) {
    return list
        .map((event) => Events(
              event["event_id"].toString(),
              event["name"].toString(),
              event["start_date"],
                event["start_time"],
                event["end_date"],
                event["end_time"],
                event["location"],
                event["description"],
                event["capacity"].toString(),
              ))
          .toList();
  } else {
    print('No events found in database');
    return [];
  }
}
Future<List<String>> getReservedEvents() async {
  if (supabase.auth.currentUser == null) {
    return [];
  }

  final list = await supabase
      .from('reservations')
      .select('event_id')
      .eq('user_id', supabase.auth.currentUser!.id).eq('has_entered', false);

  print('Fetched reserved events: $list'); // Debug print

  if (list.isEmpty) {
    return [];
  }
  return list.map((item) => item['event_id'] as String).toList();
  }



