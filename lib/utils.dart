import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:mobie_ticket_app/services/alert_service.dart';
import 'package:mobie_ticket_app/services/auth_service.dart';
import 'package:mobie_ticket_app/services/navigation_service.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp();
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;

  getIt.registerSingleton<AuthService>(
    AuthService(),
  );
  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );
  getIt.registerSingleton<AlertService>(
    AlertService(),
  );
}
