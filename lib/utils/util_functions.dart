import 'package:flutter/material.dart';

void showSnakbar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(text), duration: Duration(seconds: 1)));
}
  