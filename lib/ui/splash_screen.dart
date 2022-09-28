import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash_screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('assets/images/logo.png'),
              width: 150,
              height: 150,
            ),
            Text(
              'Restaurant App',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CircularProgressIndicator(
              color: secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
