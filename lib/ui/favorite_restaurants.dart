import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/widgets/card_restaurant.dart';
import 'package:dicoding_project_restaurant_app/provider/database_provider.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';
import 'package:dicoding_project_restaurant_app/utils/result_state.dart';

class FavoriteRestaurants extends StatelessWidget {
  const FavoriteRestaurants({super.key});

  Widget _buildList(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: secondaryColor,
          ));
        } else if (provider.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              var restaurant = provider.favorites[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
        } else if (provider.state == ResultState.noData) {
          return CustomErrorException(
            icon: const Icon(
              Icons.error_outline,
              size: 50,
              color: secondaryColor,
            ),
            message: provider.message,
          );
        } else if (provider.state == ResultState.error) {
          return CustomErrorException(
            icon: const Icon(
              Icons.error_outline,
              size: 50,
              color: secondaryColor,
            ),
            message: provider.message,
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
              'Favorite',
              style: TextStyle(fontSize: 32, color: primaryColor),
            ),
            Text(
              'List of your favorite restaurants',
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
