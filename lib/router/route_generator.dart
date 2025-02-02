import 'package:flutter/material.dart';
import 'package:grocery_app/authentication/presentation/phone_number_signin.dart';

import '../authentication/presentation/home.dart';
import '../authentication/presentation/landing_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const PhoneNumberSignin());
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
