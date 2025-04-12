import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/authentication/cubit/auth_cubit.dart';
import 'package:grocery_app/authentication/cubit/signin_cubit.dart';
import 'package:grocery_app/blocs/products/cart/cart_bloc.dart';
import 'package:grocery_app/models/cart/cart_repository.dart';

import 'package:grocery_app/router/route_generator.dart';
import 'package:grocery_app/theme/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => FirebaseFirestore.instance),
        RepositoryProvider(create: (_) => FirebaseAuth.instance),
        RepositoryProvider(create: (_) => sharedPreferences),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
          BlocProvider<SigninCubit>(create: (context) => SigninCubit()),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(
              firestore: context.read<FirebaseFirestore>(),
              auth: context.read<FirebaseAuth>(),
              prefs: context.read<SharedPreferences>(),
            )..add(CartInitRequested()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Grocery App',
          theme: myAppTheme,
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
