import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';

class CustomErrorException extends StatelessWidget {
  final Icon icon;
  final String message;

  const CustomErrorException(
      {Key? key, required this.icon, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
