import 'package:flutter/material.dart';

void showLoadingDialog(context) {
  showDialog(
    context: context,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

void hideLoadingDialog(context) {
  Navigator.pop(context);
}