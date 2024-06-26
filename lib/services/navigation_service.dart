import 'package:flutter/material.dart';
import 'package:mobie_ticket_app/pages/chat_page.dart';
import 'package:mobie_ticket_app/pages/home_page.dart';
import 'package:mobie_ticket_app/pages/login_page.dart';
import 'package:mobie_ticket_app/pages/register_page.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => const LoginPage(),
    "/register": (context) => const RegisterPage(),
    "/home": (context) => const HomePage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)>? get routes {
    return _routes;
  }

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  // Sử dụng pushs thay vì pushNamed vì cần truyền argument
  // Nếu pushNamed và khai báo ở trên _routes thì sẽ không truyền được argument
  void push(MaterialPageRoute route) {
    _navigatorKey.currentState?.push(route);
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }
}
