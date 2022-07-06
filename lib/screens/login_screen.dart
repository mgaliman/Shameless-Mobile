import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shameless/resources/auth_methods.dart';
import 'package:shameless/responsive/mobile_screen_layout.dart';
import 'package:shameless/responsive/responsive_layout_screen.dart';
import 'package:shameless/responsive/web_screen_layout.dart';
import 'package:shameless/screens/signup_screen.dart';
import 'package:shameless/utils/colors.dart';
import 'package:shameless/utils/utils.dart';
import 'package:shameless/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "Succes") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Flexible(
          child: Container(),
          flex: 2,
        ),
        SvgPicture.asset(
          'assets/shameless.svg',
          color: primaryColor,
          height: 64,
        ),
        const SizedBox(height: 64),
        TextFieldInput(
            textEditingController: _emailController,
            hintText: "Enter your email",
            textInputType: TextInputType.emailAddress),
        const SizedBox(height: 24),
        TextFieldInput(
          textEditingController: _passwordController,
          hintText: "Enter your password",
          textInputType: TextInputType.text,
          isPass: true,
        ),
        const SizedBox(height: 24),
        InkWell(
          onTap: loginUser,
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                color: blueColor),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : const Text('Log In'),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Flexible(
          flex: 2,
          child: Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text("Don't have account? "),
            ),
            GestureDetector(
              onTap: navigateToSignup,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  "Sign up.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        )
      ]),
    )));
  }
}
