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

Future<void> reserveEventWithTeam(String eventId, List<String> teamEmails) async {
  final userId = getCurrentUserId();
  if (userId == null) throw Exception('User not logged in');
  
  // Insert main reservation with team emails
  await supabase.from('reservations').insert({
    'event_id': eventId,
    'user_id': userId,
    'team_emails': teamEmails, // Store as JSON array
  });
}

Future<bool> checkIfReserved(String eventId) async {
  try {
    final user_id = getCurrentUserId();
    if (user_id == null) return false;
    
    // Use maybeSingle instead of single
    final result = await supabase
        .from('reservations')
        .select()
        .eq('event_id', eventId)
        .eq('user_id', user_id)
        .maybeSingle();
    
    // Return true if NOT reserved (null means no reservation found)
    return result == null;
    
  } catch (error) {
    print("Error checking reservation: $error");
    return false;
  }
}

Future<void> addCheckinToSupabase(String eventId) async {
  try {
    print("\nAdding check-in for event: $eventId");
    final userId = Supabase.instance.client.auth.currentUser?.id;
    
    if (userId == null) {
      print("Error: No user logged in");
      return;
    }
    
    print("User ID: $userId");
    
    // Update the reservation with count
    await Supabase.instance.client
        .from('reservations')
        .update({'has_entered': true})
        .eq('event_id', eventId)
        .eq('user_id', userId);
    
  } catch (error) {
    print("Error updating check-in: $error");
  }
}

Future<bool> checkIfEntered(String eventId) async {
  try {
    final user_id = getCurrentUserId();
    if (user_id == null) return false;
    
    // Use maybeSingle instead of single
    final result = await supabase
        .from('reservations')
        .select()
        .eq('event_id', eventId)
        .eq('user_id', user_id)
        .maybeSingle();
    
    // If no reservation, return false
    if (result == null) return false;
    
    // Return has_entered status
    return result['has_entered'] ?? false;
    
  } catch (error) {
    print("Error checking entry status: $error");
    return false;
  }
}