import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

String? getCurrentUserId() {
  final user = supabase.auth.currentUser;
  print('Auth Check - Current User: ${user?.email}'); // Debug user info
  print('Auth Check - User ID: ${user?.id}'); // Debug user ID
  print('Auth Check - User Meta: ${user?.userMetadata}'); // Debug metadata
  return user?.id;
}

void reserveEvent(String eventId) async {
  final userId = getCurrentUserId();
  if (userId == null) return;
  await supabase
      .from('reservations')
      .insert({'event_id': eventId, 'user_id': userId});
}

Future<bool> checkIfReserved(String eventId) async {
  print("Checking reservation status for event: $eventId");
  final user_id = getCurrentUserId();
  if (user_id == null) return false;
  final response = await supabase
      .from('reservations')
      .select()
      .eq('event_id', eventId)
      .eq('user_id', user_id)
      .single();

  return response.isEmpty;
}