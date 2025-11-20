import 'package:eventa/models/events.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<String?> makeEvent(Events event) async {
  try {
    // Use .select() to get the data back after inserting
    final response = await supabase
        .from('events')
        .insert({
          'name': event.name,
          'description': event.description,
          'location': event.location,
          'start_date': event.start_date,
          'end_date': event.end_date,
          'start_time': event.start_time,
          'end_time': event.end_time,
          'capacity': event.capacity,
        })
        .select()
        .single();
    
    // Now response has data
    return response['event_id'];
  } catch (e) {
    print('Error creating event: $e');
    return null;
  }
}

Future<void> updateEvent(Events event) async {
  await supabase.from('events').update({
    'name': event.name,
    'description': event.description,
    'location': event.location,
    'start_date': event.start_date,
    'end_date': event.end_date,
    'start_time': event.start_time,
    'end_time': event.end_time,
    'capacity': event.capacity,
  }).eq('event_id', event.events_id);
}