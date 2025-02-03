import 'package:flutter/material.dart';
import 'package:grocery_app/authentication/presentation/otp_screen.dart';
import 'package:grocery_app/authentication/presentation/phone_number_signin.dart';

import '../authentication/presentation/app.dart';
import '../authentication/presentation/home.dart';
import '../authentication/presentation/landing_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/signinsignup':
        return MaterialPageRoute(builder: (_) => const App());
      case '/otpscreen':
        return MaterialPageRoute(builder: (_) => const OTPScreen());

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
