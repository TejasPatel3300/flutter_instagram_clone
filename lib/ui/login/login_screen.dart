import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/constants/assets.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/resources/auth_manager.dart';
import 'package:instagram_clone/utils/custom_text_input.dart';

import '../../constants/strings.dart';
import '../../utils/helpers.dart';

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
                hint: Strings.enterEmail,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              CustomTextInput(
                textEditingController: _passwordController,
                hint: Strings.enterPassword,
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

  /// widget to show sign-up option text
  Widget _signUpText() {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(Strings.doNotHaveAccount),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              Strings.login,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// widget for login button
  Widget _loginButton() {
    return InkWell(
      onTap: _loginUser,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: AppColors.blueColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: _isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              )
            : const Text(Strings.login),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// login user
  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    final response = await AuthManager().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (response != Strings.success) {
      if (mounted) {
        showSnackBar(context, response);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
