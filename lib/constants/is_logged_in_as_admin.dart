import '../functions/admin_priveleges.dart';

bool is_admin = false;

Future<void> setAdminStatus() async {
  is_admin = await isAdmin() ;
}