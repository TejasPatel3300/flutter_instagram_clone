import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/constants/assets.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/utils/custom_text_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.logo, color: AppColors.primaryColor),
                ],
              ),
              const SizedBox(height: 60),
              CustomTextInput(
                textEditingController: _emailController,
                hint: 'Enter email',
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              CustomTextInput(
                textEditingController: _passwordController,
                hint: 'Enter password',
                inputType: TextInputType.emailAddress,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              _loginButton(),
              const Expanded(child: SizedBox()),
              _signUpText(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signUpText() {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Don\'t have an account?'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Sign up',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () {
        print('object');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: AppColors.blueColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: const Text('Log in'),
      ),
    );
  }
}
