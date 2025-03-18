import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_thumb_extract/core/Keys/form_keys.dart';
import 'package:yt_thumb_extract/core/constants/app_colors.dart';
import 'package:yt_thumb_extract/core/utils/password_validator.dart';
import 'package:yt_thumb_extract/data/services/controllers/users_controllers.dart';
import 'package:yt_thumb_extract/presentation/screens/auth/login_screen.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_button.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool obscureText = true;
  bool isDisabled = false;
  final GlobalKey<FormState> _formKey = AppKeys.registrationFormKey;

  String passwordStrength = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Hide keyboard on tap
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Prevents text fields from going off-screen
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
                            colors: [AppColors.primary, AppColors.primary],
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
                          const SizedBox(height: 50),
                          Text(
                            "Create New Account",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Name Field
                          CustomTextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name is required";
                              }
                              return null;
                            },
                            prefixIcon: Icons.contact_emergency,
                            hintText: "Name*",
                          ),
                          const SizedBox(height: 20),

                          // Mobile Number Field
                          CustomTextFormField(
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Mobile number is required";
                              }
                              return null;
                            },
                            prefixIcon: Icons.phone,
                            hintText: "Mobile Number",
                          ),
                          const SizedBox(height: 20),

                          // Password Field with Strength Checker
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
                            onChange: (value) {
                              setState(() {
                                passwordStrength =
                                    PasswordValidator.getPasswordStrength(
                                        value!);
                              });
                              return null;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                            prefixIcon: Icons.password,
                            obscureText: obscureText,
                            hintText: "Password (ex: UserName@12345)",
                          ),

                          const SizedBox(height: 20),

                          LinearProgressIndicator(
                            value: PasswordValidator.getStrengthProgress(
                                passwordStrength),
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation(
                                PasswordValidator.getStrengthColor(
                                    passwordStrength)),
                          ),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              passwordStrength,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: PasswordValidator.getStrengthColor(
                                    passwordStrength),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Register Button
                          YoutubeButton(
                            disabled: isDisabled,
                            text: "Register",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                errorLens();
                              }
                            },
                          ),

                          const SizedBox(height: 20),

                          // Already have an account?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/login');
                                },
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30), // Extra bottom padding
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

  void errorLens() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isDisabled = true;
      });

      AuthController.register(
              name: nameController.text,
              mobile: mobileController.text,
              password: passwordController.text,
              context: context)
          .then((value) {
        setState(() {
          isDisabled = false;
        });
      });
    }
  }
}
