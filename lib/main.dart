import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/common/navigation.dart';
import 'package:dicoding_project_restaurant_app/home.dart';
import 'package:dicoding_project_restaurant_app/ui/splash_screen.dart';
import 'package:dicoding_project_restaurant_app/ui/restaurant_detail.dart';
import 'package:dicoding_project_restaurant_app/ui/review.dart';
import 'package:dicoding_project_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_project_restaurant_app/data/db/database_helper.dart';
import 'package:dicoding_project_restaurant_app/provider/database_provider.dart';
import 'package:dicoding_project_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_project_restaurant_app/utils/background_service.dart';
import 'package:dicoding_project_restaurant_app/utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.black,
              secondary: secondaryColor,
            ),
        textTheme: myTextTheme,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        Home.routeName: (context) => const Home(),
        RestaurantDetailPage.routeName: (context) => ChangeNotifierProvider(
            create: (_) => RestaurantDetailProvider(
                apiService: ApiService(),
                id: ModalRoute.of(context)!.settings.arguments as String),
            child: ChangeNotifierProvider<DatabaseProvider>(
              create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
              child: RestaurantDetailPage(
                id: ModalRoute.of(context)!.settings.arguments as String,
              ),
            )),
        Review.routeName: (context) => ChangeNotifierProvider(
              create: (_) => RestaurantDetailProvider(
                  apiService: ApiService(),
                  id: ModalRoute.of(context)!.settings.arguments as String),
              child: Review(
                id: ModalRoute.of(context)!.settings.arguments as String,
              ),
            ),
      },
    );
  }
}
