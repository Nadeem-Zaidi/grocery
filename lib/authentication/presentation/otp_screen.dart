import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/authentication/cubit/signin_cubit.dart';

import '../../utils/screen_utils.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<FocusNode> _focusNode = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controller =
      List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNode) {
      node.dispose();
    }
    for (var controller in _controller) {
      controller.dispose();
    }
    super.dispose();
  }

  void _moveNextField(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNode[index + 1].requestFocus();
    }
  }

  void _movePreviousField(int index, String value) {
    if (value.isEmpty && index > 0) {
      _focusNode[index - 1].requestFocus();
    }
  }

  final _formKey = GlobalKey<FormState>();
  void getOTP() {
    String otp = "";
    for (int i = 0; i < 6; i++) {
      otp += _controller[i].text.trim();
    }

    context.read<SigninCubit>().smsCodeChanged(smsCode: otp);
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      context.read<SigninCubit>().verifySmsCode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Verification",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("You will get an OTP via SMS",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) {
                      return SizedBox(
                        width: screenWidth * 0.13,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: _controller[index],
                          focusNode: _focusNode[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onChanged: (value) {
                            _moveNextField(index, value);
                            _movePreviousField(index, value);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      getOTP();
                      _onSave();
                    },
                    child: const Text("Verify OTP"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
