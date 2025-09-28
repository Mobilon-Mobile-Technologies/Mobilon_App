import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<bool> isAdmin() async {
  final user = supabase.auth.currentUser;
  if (user == null) return false;

  final response = await supabase
      .from('admins')
      .select('id')
      .eq('id', user.id)
      .maybeSingle();

  return response?.isNotEmpty ?? false;
}