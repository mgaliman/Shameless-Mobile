import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shameless/resources/auth_methods.dart';
import 'package:shameless/responsive/mobile_screen_layout.dart';
import 'package:shameless/responsive/responsive_layout_screen.dart';
import 'package:shameless/responsive/web_screen_layout.dart';
import 'package:shameless/screens/login_screen.dart';
import 'package:shameless/utils/colors.dart';
import 'package:shameless/utils/utils.dart';
import 'package:shameless/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (result != 'Succes') {
      showSnackBar(result, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
  }

/* 
  () async {
            String result = await AuthMethods().signUpUser(
                email: _emailController.text,
                password: _passwordController.text,
                username: _usernameController.text,
                bio: _bioController.text,
                file: _image!);
            print(result);
          }, */

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
        Stack(
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                  ),
            Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Colors.yellow,
                  ),
                ))
          ],
        ),
        const SizedBox(height: 24),
        TextFieldInput(
            textEditingController: _usernameController,
            hintText: "Enter your username",
            textInputType: TextInputType.text),
        const SizedBox(height: 24),
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
        TextFieldInput(
            textEditingController: _bioController,
            hintText: "Enter your bio",
            textInputType: TextInputType.text),
        const SizedBox(height: 24),
        InkWell(
          onTap: signUpUser,
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
                : const Text('Sign up'),
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
              child: const Text("Already have an account? "),
            ),
            GestureDetector(
              onTap: navigateToLogin,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  "Log in.",
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
