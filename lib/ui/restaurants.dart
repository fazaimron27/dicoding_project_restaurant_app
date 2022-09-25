import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/widgets/card_restaurant.dart';
import 'package:dicoding_project_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';

class Restaurants extends StatelessWidget {
  const Restaurants({super.key});

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: secondaryColor,
          ));
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
        } else if (state.state == ResultState.noData) {
          return CustomErrorException(
            icon: const Icon(
              Icons.error_outline,
              size: 50,
              color: secondaryColor,
            ),
            message: state.message,
          );
        } else if (state.state == ResultState.error) {
          return CustomErrorException(
            icon: const Icon(
              Icons.error_outline,
              size: 50,
              color: secondaryColor,
            ),
            message: state.message,
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
