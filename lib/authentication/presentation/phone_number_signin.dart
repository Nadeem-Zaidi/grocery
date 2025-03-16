import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/authentication/cubit/signin_cubit.dart';

import '../../utils/screen_utils.dart';

class PhoneNumberSignin extends StatefulWidget {
  const PhoneNumberSignin({super.key});

  @override
  State<PhoneNumberSignin> createState() => _PhoneNumberSigninState();
}

class _PhoneNumberSigninState extends State<PhoneNumberSignin> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final borderRadius = screenWidth * 0.025;
    final mainContainerMargin =
        screenHeight * 0.10; // Adjusted for better responsiveness

    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents overflow when keyboard opens
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          "Use your Phone Number to sign in",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: screenHeight * 0.10,
                          child: TextFormField(
                            controller: _controller,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            style: const TextStyle(fontSize: 22),
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              prefixText: "+91",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              print("+91$value".trim());
                              context.read<SigninCubit>().phoneNumberChanged(
                                  phoneNumber: "+91$value".trim());
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: screenHeight * 0.065,
                          child: ElevatedButton(
                            onPressed: () {
                              print("from inside");
                              context
                                  .read<SigninCubit>()
                                  .signInWithPhoneNumber();
                            },
                            child: const Text("Sign In"),
                          ),
                        ),
                        const Spacer(), // Pushes the remaining widgets up when the keyboard appears
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.40,
                              child: const Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                            Text(
                              "OR",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(
                              width: screenWidth * 0.40,
                              child: const Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/google.png",
                              height: 35,
                              width: 35,
                            ),
                            const SizedBox(width: 10),
                            Image.asset(
                              "assets/images/apple.png",
                              height: 35,
                              width: 35,
                            ),
                            const SizedBox(width: 10),
                            Image.asset(
                              "assets/images/tx.png",
                              height: 35,
                              width: 35,
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
