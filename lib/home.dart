import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/ui/search.dart';
import 'package:dicoding_project_restaurant_app/ui/settings.dart';
import 'package:dicoding_project_restaurant_app/ui/restaurants.dart';
import 'package:dicoding_project_restaurant_app/ui/restaurant_detail.dart';
import 'package:dicoding_project_restaurant_app/ui/favorite_restaurants.dart';
import 'package:dicoding_project_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_project_restaurant_app/data/db/database_helper.dart';
import 'package:dicoding_project_restaurant_app/data/preferences/preferences_helper.dart';
import 'package:dicoding_project_restaurant_app/provider/search_provider.dart';
import 'package:dicoding_project_restaurant_app/provider/database_provider.dart';
import 'package:dicoding_project_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_project_restaurant_app/provider/scheduling_provider.dart';
import 'package:dicoding_project_restaurant_app/provider/preferences_provider.dart';
import 'package:dicoding_project_restaurant_app/utils/notification_helper.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    selectNotificationSubject.close();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    ChangeNotifierProvider<RestaurantsProvider>(
      create: (_) => RestaurantsProvider(apiService: ApiService()),
      child: ChangeNotifierProvider<DatabaseProvider>(
        create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        child: const Restaurants(),
      ),
    ),
    ChangeNotifierProvider<DatabaseProvider>(
      create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
      child: const FavoriteRestaurants(),
    ),
    // ChangeNotifierProvider<SearchProvider>(
    //   create: (_) => SearchProvider(apiService: ApiService()),
    //   child: const Search(),
    // ),
    ChangeNotifierProvider<SearchProvider>(
      create: (_) => SearchProvider(apiService: ApiService()),
      child: ChangeNotifierProvider<DatabaseProvider>(
        create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        child: const Search(),
      ),
    ),
    ChangeNotifierProvider<SchedulingProvider>(
      create: (_) => SchedulingProvider(),
      child: ChangeNotifierProvider<PreferencesProvider>(
        create: (_) => PreferencesProvider(
          preferencesHelper: PreferencesHelper(
            sharedPreferences: SharedPreferences.getInstance(),
          ),
        ),
        child: const SettingsPage(),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _connectionStatus == ConnectivityResult.none
            ? const CustomErrorException(
                icon: Icon(
                  Icons.signal_wifi_off,
                  color: secondaryColor,
                  size: 100.0,
                ),
                message: 'No Internet Connection',
              )
            : _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            fixedColor: secondaryColor,
            unselectedItemColor: Colors.grey,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.food_bank_outlined),
                label: 'Home',
                activeIcon: Icon(Icons.food_bank_outlined),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Favorites',
                activeIcon: Icon(Icons.favorite),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
                activeIcon: Icon(Icons.search_sharp),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
                activeIcon: Icon(Icons.settings),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
