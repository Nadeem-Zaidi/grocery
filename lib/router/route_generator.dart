import 'package:flutter/material.dart';
import 'package:grocery_app/authentication/presentation/otp_screen.dart';
import 'package:grocery_app/authentication/presentation/phone_number_signin.dart';
import 'package:grocery_app/categories/create_categories/create_category.dart';
import 'package:grocery_app/pages/create_category_page.dart';

import '../authentication/presentation/app.dart';
import '../pages/home.dart';
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
      case '/createcategory':
        return MaterialPageRoute(builder: (_) => const CreateCategorypage());

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
