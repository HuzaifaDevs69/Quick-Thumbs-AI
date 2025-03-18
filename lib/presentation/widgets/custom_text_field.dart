import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_thumb_extract/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController urlController;
  final void Function(String) onChange;
  final Function() onPress;

  const CustomTextField(
      {super.key,
      required this.urlController,
      required this.onChange,
      required this.onPress});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Glow Color Animation (YouTube Dark Mode Inspired)
    _colorAnimation = ColorTween(
      begin: Colors.redAccent.withOpacity(0.7), // Bright red
      end: Colors.deepOrange.withOpacity(0.9), // Deep orange
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.urlController.dispose();
    super.dispose();
  }

  void _closeKeyboard() {
    FocusScope.of(context).unfocus(); // Close the keyboard
  }

  void _selectAllText() {
    widget.urlController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.urlController.text.length,
    ); // Select all text
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      color: AppColors.scaffoldColor,
      child: Form(
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  // Intense Red Glow
                  BoxShadow(
                    color: _colorAnimation.value!.withOpacity(0.8),
                    blurRadius: 24.0,
                    spreadRadius: 6.0,
                  ),
                  // Subtle Inner White Glow for Contrast
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 12.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.done,
                controller: widget.urlController,
                onChanged: widget.onChange,
                onFieldSubmitted: widget.onChange,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  suffixIcon:
                      // SizedBox(width: 8), // Adjust spacing between buttons
                      IconButton(
                    icon: Icon(Icons.paste, color: Colors.white),
                    onPressed: () {
                      // _closeKeyboard(); // Close keyboard when paste is pressed
                      widget.onPress(); // Call the provided onPress function
                    },
                  ).paddingOnly(right: 8),
                  hintText: "Paste Link Here...",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  filled: true,
                  fillColor: AppColors.textfieldFilledColor,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _colorAnimation.value!,
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _colorAnimation.value!,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function? Function(String?)? onChange;
  final IconData prefixIcon;
  final Widget? suffixIcon; // Optional suffix icon
  final String hintText;
  final bool obscureText;
  final Color fillColor;
  final int? maxLength;
  final InputBorder? border; // Optional custom border

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.keyboardType,
    required this.validator,
    required this.prefixIcon,
    this.suffixIcon, // Non-required parameter
    required this.hintText,
    this.maxLength,
    this.obscureText = false,
    this.fillColor = const Color(0xFFF5F5F5), // Default light gray
    this.border,
    this.onChange, // Allows custom borders, fallback to default
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  // Shake animation
  void shake() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reset();
      _controller.forward();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final sineValue =
            sin(4 * 2 * pi * _controller.value); // Adding sine wave shake
        return Transform.translate(
          offset: Offset(
              sineValue * 10, 0), // Adjust the multiplier for shake intensity
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            validator: (value) {
              final errorMessage = widget.validator?.call(value);
              if (errorMessage != null) {
                shake(); // Trigger shake animation on error
              }
              return errorMessage;
            },
            obscureText: widget.obscureText,
            maxLength: widget.maxLength,
            onChanged: widget.onChange,
            style: const TextStyle(color: AppColors.darkPrimary), // Text color
            cursorColor: AppColors.primary, // Cursor color
            decoration: InputDecoration(
              counterText: "",
              prefixIcon: Icon(widget.prefixIcon, color: Colors.grey),
              suffixIcon: widget.suffixIcon,
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: AppColors.secondary),
              filled: true,
              fillColor: widget.fillColor,
              errorStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w700),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              border: widget.border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
              enabledBorder: widget.border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
              focusedBorder: widget.border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
              errorBorder: widget.border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
              focusedErrorBorder: widget.border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
