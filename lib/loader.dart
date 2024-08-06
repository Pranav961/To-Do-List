import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void showLoadingDialog(context) {
  showDialog(
    context: context,
    builder: (context) =>  Center(
      // child: CircularProgressIndicator(backgroundColor: Colors.white,color: Color(0xFF0192ED)),
      child: LoadingAnimationWidget.inkDrop(
        color: Colors.white,
        size: 40,
      ),
    ),
  );
}

void hideLoadingDialog(context) {
  Navigator.pop(context);
}