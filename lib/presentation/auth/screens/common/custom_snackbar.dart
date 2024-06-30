import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/border_radius.dart';
import '../../../../core/colors.dart';

SnackbarController customSnackbar({required String message, String? title}) {
  return Get.showSnackbar(GetSnackBar(
    borderColor: kPrimaryLightColor,
    borderRadius: borderRadius,
    backgroundGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [kPrimaryColor, kSecondaryColor, dividerColor]),
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.all(10),
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
    snackPosition: SnackPosition.BOTTOM,
  ));
}
