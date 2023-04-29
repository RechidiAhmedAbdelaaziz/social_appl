import 'package:flutter/material.dart';
import 'package:social_appl/Shared/Compenents/compenents.dart';

class NewPostScreen  extends StatelessWidget {
  const NewPostScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context,title: 'Create a post'),
      
    );
  }
}