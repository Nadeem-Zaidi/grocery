import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/authentication/cubit/auth_cubit.dart';
import 'package:grocery_app/authentication/cubit/signin_cubit.dart';
import 'package:grocery_app/categories/widgets/category_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
            listenWhen: (p, c) => p.isLoggedIn != c.isLoggedIn && !c.isLoggedIn,
            listener: (context, state) {
              Navigator.of(context).pushReplacementNamed('/signinsignup');
            })
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Welcome Screen",
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            IconButton(
              icon: Icon(Icons.logout), // Logout icon
              onPressed: () {
                context.read<AuthCubit>().signOut();
              }, // Call the logout function
              tooltip: 'Logout', // Tooltip for the button
            ),
          ],
        ),
        body: Center(
          child: Text(
            "This will be the Welcome Screen. Development in progress",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        drawer: CategoryDrawer(),
      ),
    );
  }
}
