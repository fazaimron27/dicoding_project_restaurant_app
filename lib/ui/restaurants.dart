import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant.dart';
import 'package:dicoding_project_restaurant_app/widgets/card_restaurant.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({super.key});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  late Future<RestaurantsResult> _restaurants;

  @override
  void initState() {
    super.initState();
    _restaurants = ApiService().getAllRestaurants();
  }

  Widget _buildList(BuildContext context) {
    return FutureBuilder(
      future: _restaurants,
      builder: (context, AsyncSnapshot<RestaurantsResult> snapshot) {
        var state = snapshot.connectionState;
        if (state != ConnectionState.done) {
          return const Center(
              child: CircularProgressIndicator(
            color: secondaryColor,
          ));
        } else {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = snapshot.data?.restaurants[index];
                return CardRestaurant(restaurant: restaurant!);
              },
            );
          } else if (snapshot.hasError) {
            return CustomErrorException(
              icon: const Icon(
                Icons.error_outline,
                size: 50,
                color: secondaryColor,
              ),
              message: snapshot.error.toString().split('Exception: ')[1],
            );
          } else {
            return const CustomErrorException(
              icon: Icon(
                Icons.error_outline,
                size: 50,
                color: secondaryColor,
              ),
              message: 'Something went wrong',
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Restaurants",
              style: TextStyle(fontSize: 32, color: primaryColor),
            ),
            Text(
              "Recommended restaurants for you!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: _buildList(context),
    );
  }
}
