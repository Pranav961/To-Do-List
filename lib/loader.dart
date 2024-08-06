import 'package:flutter/material.dart';

void showLoadingDialog(context) {
  showDialog(
    context: context,
    builder: (context) => const Center(
      child: CircularProgressIndicator(backgroundColor: Colors.white,color: Color(0xFF0192ED)),
    ),
  );
}

void hideLoadingDialog(context) {
  Navigator.pop(context);
}