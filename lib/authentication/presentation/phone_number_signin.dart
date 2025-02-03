import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_app/authentication/cubit/signin_cubit.dart';

import '../../utils/screen_utils.dart';

class PhoneNumberSignin extends StatefulWidget {
  const PhoneNumberSignin({super.key});

  @override
  State<PhoneNumberSignin> createState() => _PhoneNumberSigninState();
}

class _PhoneNumberSigninState extends State<PhoneNumberSignin> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final isPortrait = ScreenUtils.isPortrait(context);
    final borderRadius = screenWidth * 0.025;
    final mainContainerMargin = screenWidth * 0.70;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(top: mainContainerMargin),
        child: Form(
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixText: "+91",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        print("+91${value}".trim());
                        context.read<SigninCubit>().phoneNumberChanged(
                            phoneNumber: "+91${value}".trim());
                      },
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          print("from inside");
                          context.read<SigninCubit>().signInWithPhoneNumber();
                        },
                        child: const Text("Sign In"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.40,
                      child: Divider(
                        color: Colors.grey, // Line color
                        thickness: 1, // Line thickness
                        height: 20,
                        // Space above and below the line
                      ),
                    ),
                    Text(
                      "OR",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(
                      width: screenWidth * 0.40,
                      child: Divider(
                        color: Colors.grey, // Line color
                        thickness: 1, // Line thickness
                        height: 20, // Space above and below the line
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
