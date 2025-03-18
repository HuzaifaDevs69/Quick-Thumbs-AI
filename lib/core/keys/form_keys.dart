import 'package:flutter/material.dart';

class AppKeys {
  AppKeys._(); // Private constructor

  static GlobalKey<FormState> get loginFormKey => GlobalKey<FormState>();
  static GlobalKey<FormState> get registrationFormKey => GlobalKey<FormState>();
  static GlobalKey<FormState> get profileUpdateFormKey =>
      GlobalKey<FormState>();
}
