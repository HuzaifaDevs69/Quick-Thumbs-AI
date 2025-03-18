import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_thumb_extract/core/Keys/form_keys.dart';
import 'package:yt_thumb_extract/core/constants/app_colors.dart';
import 'package:yt_thumb_extract/core/utils/app_regex.dart';
import 'package:yt_thumb_extract/data/services/controllers/users_controllers.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_button.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = AppKeys.loginFormKey;

  bool obscureText = true;
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard when tapped outside
      },
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Ensures screen resizes when keyboard appears
        backgroundColor: AppColors.scaffoldColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height, // Full height

              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: ClipPath(
                      clipper: RoundedTopClipper(),
                      child: Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 80), // Adjust space

                          // Welcome Text
                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),

                          CustomTextFormField(
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Mobile number is required";
                              }
                              if (!AppRegex.mobileNumberRegex.hasMatch(value)) {
                                return "Enter a valid 10-digit mobile number";
                              }
                              return null;
                            },
                            prefixIcon: Icons.phone,
                            hintText: "Mobile Number*",
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          CustomTextFormField(
                            controller: passwordController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: obscureText
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                            prefixIcon: Icons.password,
                            obscureText: obscureText,
                            hintText: "Password (ex: UserName@12345)*",
                          ),
                          const SizedBox(height: 20),

                          YoutubeButton(
                            disabled: isDisabled,
                            text: "Login",
                            onPressed: () {
                              errorLens();
                            },
                          ),
                          const SizedBox(height: 20),

                          // Don't have an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/register');
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                              height: 30), // Extra space at the bottom
                        ],
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Dummy Sign-In Method
  void errorLens() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isDisabled = true;
      });

      AuthController.login(
              mobile: mobileController.text,
              pass: passwordController.text,
              context: context)
          .then((value) => {
                setState(() {
                  isDisabled = false;
                })
              });
    }
  }
}

// Custom clipper for rounded top left corner
class RoundedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
