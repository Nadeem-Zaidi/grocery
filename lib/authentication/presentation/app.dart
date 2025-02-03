import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/authentication/cubit/signin_cubit.dart';
import 'package:grocery_app/authentication/presentation/otp_screen.dart';
import 'package:grocery_app/authentication/presentation/phone_number_signin.dart';
import '../../widget/overlay.dart';

import '../cubit/auth_cubit.dart';
import '../domain/auth_failure.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (p, c) => p.isLoggedIn != c.isLoggedIn && c.isLoggedIn,
            listener: (context, state) {
              Navigator.of(context).pushReplacementNamed("/home");
              context.read<SigninCubit>().reset();
            },
          ),
          // BlocListener<SigninCubit, SigninState>(
          //   listenWhen: (p, c) => p.failureOptions != c.failureOptions,
          //   listener: (context, state) {
          //     state.failureOptions.fold(() {}, (AuthFailure failure) {
          //       OverlayHelper.removeOverlay();
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(failure.when(
          //             serverError: () => "Server Error",
          //             invalidPhoneNumber: () => "Invalid Phone Number",
          //             tooManyRequests: () => "Too Many Requests",
          //             deviceNotSupported: () => "Device Not Supported",
          //             smsTimeout: () => "Sms Timeout",
          //             sessionExpired: () => "Session Expired",
          //             genericError: (errp) => errp.toString(),
          //             invalidFormat: () => "Invalid format.", // Add this line.
          //             invalidVerificationCode: () =>
          //                 "Invalid Verification Code",
          //           )),
          //         ),
          //       );

          //       // context.read<PhoneNumberSignInCubit>().reset();
          //     });
          //   },
          // ),
          BlocListener<SigninCubit, SigninState>(
              listenWhen: (previous, current) =>
                  previous.isInProgress != current.isInProgress ||
                  previous.verificationIdOption != current.verificationIdOption,
              listener: (ctx, state) {
                OverlayHelper.removeOverlay();
                if (state.isInProgress && state.verificationIdOption.isNone()) {
                  OverlayHelper.showOverlay(context, "Sending OTP");
                }
                if (state.isInProgress && state.verificationIdOption.isSome()) {
                  OverlayHelper.showOverlay(context, "Verifying OTP");
                }
              })
        ],
        child: BlocBuilder<SigninCubit, SigninState>(
          builder: (context, state) {
            print("*****from app2*********");
            print(state.displaySmsCodeForm);
            print("*****app2**********");
            if (state.displaySmsCodeForm) {
              return const OTPScreen();
            } else {
              return const PhoneNumberSignin();
            }
          },
        ),
      ),
    );
  }
}
