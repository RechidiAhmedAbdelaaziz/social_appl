// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  ErrorScreen({super.key , required this.text});
  String? text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$text'),
    );
  }
}
