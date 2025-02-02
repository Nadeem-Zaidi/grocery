import 'package:flutter/material.dart';

import '../../utils/screen_utils.dart';

class PhoneNumberSignin extends StatefulWidget {
  const PhoneNumberSignin({super.key});

  @override
  State<PhoneNumberSignin> createState() => _PhoneNumberSigninState();
}

class _PhoneNumberSigninState extends State<PhoneNumberSignin> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final isPortrait = ScreenUtils.isPortrait(context);
    final borderRadius = screenWidth * 0.025;
    final mainContainerMargin = screenWidth * 0.70;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: mainContainerMargin),
        child: Form(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
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
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Sign In"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
