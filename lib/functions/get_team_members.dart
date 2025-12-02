import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

/// Converts JSONB team_emails field to a List<String>
List<String> parseTeamEmails(dynamic teamEmailsJson) {
  if (teamEmailsJson == null) {
    return [];
  }
  
  try {
    // If it's already a List, just cast it
    if (teamEmailsJson is List) {
      return teamEmailsJson.map((e) => e.toString()).toList();
    }
    
    // If it's a String, parse it as JSON
    if (teamEmailsJson is String) {
      final decoded = jsonDecode(teamEmailsJson);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    }
    
    return [];
  } catch (e) {
    print('Error parsing team emails: $e');
    return [];
  }
}

/// Gets team members for a specific event reservation
Future<List<String>> getTeamMembers(String eventId) async {
  try {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    
    final response = await supabase
        .from('reservations')
        .select('team_emails')
        .eq('event_id', eventId)
        .eq('user_id', userId)
        .maybeSingle();
    
    if (response == null) {
      return [];
    }
    
    return parseTeamEmails(response['team_emails']);
  } catch (e) {
    print('Error fetching team members: $e');
    return [];
  }
}