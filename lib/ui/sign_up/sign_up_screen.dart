import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../resources/auth_manager.dart';
import '../../utils/custom_text_input.dart';
import '../../utils/helpers.dart';
import '../../utils/size_config.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  bool _isLoading = false;
  Uint8List? _profileImage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Assets.logo,
                        color: AppColors.primaryColor),
                  ],
                ),
                const SizedBox(height: 60),
                _profileImageWidget(),
                const SizedBox(height: 20),
                CustomTextInput(
                  textEditingController: _userNameController,
                  hint: Strings.enterUserName,
                  inputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextInput(
                  textEditingController: _emailController,
                  hint: Strings.enterEmail,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomTextInput(
                  textEditingController: _passwordController,
                  hint: Strings.enterPassword,
                  inputType: TextInputType.text,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                CustomTextInput(
                  textEditingController: _bioController,
                  hint: Strings.enterBio,
                  inputType: TextInputType.text,
                ),
                const SizedBox(height: 24),
                _signUpButton(),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImageWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _profileImage != null
            ? CircleAvatar(
                radius: 60,
                backgroundImage: MemoryImage(_profileImage!),
              )
            : const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(Assets.profilePlaceholder),
              ),
        Positioned(
          bottom: -10,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.blueColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: _selectImage,
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: _signUpUser,
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
            : const Text(Strings.signUp),
      ),
    );
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      _profileImage = await file.readAsBytes();
      setState(() {});
    }
  }

  Future<void> _signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    final res = await AuthManager().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      userName: _userNameController.text,
      bio: _bioController.text,
      profilePicture: _profileImage,
    );
    if (kDebugMode) {
      print(res);
    }

    if (res != Strings.success) {
      if (mounted) {
        showSnackBar(context, res);
      }
    }else {
      if(mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              webLayout: WebScreenLayout(),
              mobileLayout: MobileScreenLayout(),
            ),
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
    super.dispose();
  }
}
