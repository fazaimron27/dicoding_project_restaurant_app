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
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.clip,
                color: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
