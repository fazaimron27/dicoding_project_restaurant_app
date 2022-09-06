import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/models/restaurant.dart';
import 'package:dicoding_project_restaurant_app/utils/ratings.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';
import 'package:dicoding_project_restaurant_app/ui/restaurant_detail.dart';

class Restaurants extends StatelessWidget {
  const Restaurants({super.key});

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
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/data/local_restaurant.json'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator(
              color: secondaryColor,
            );
          }
          if (!snapshot.hasData) {
            return const CustomErrorException(
              icon: Icon(
                Icons.dangerous_rounded,
                size: 50,
                color: secondaryColor,
              ),
              message: "Failed to load data",
            );
          }
          final List<RestaurantElement> restaurants =
              restaurantFromJson(snapshot.data.toString()).restaurants;

          if (restaurants.isEmpty) {
            return const CustomErrorException(
              icon: Icon(
                Icons.warning_rounded,
                size: 50,
                color: secondaryColor,
              ),
              message: "Restaurant not found",
            );
          }

          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final RestaurantElement restaurant = restaurants[index];
              return _BuildRestaurantItem(restaurant: restaurant);
            },
          );
        },
      ),
    );
  }
}

class _BuildRestaurantItem extends StatelessWidget {
  const _BuildRestaurantItem({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  final RestaurantElement restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetail.routeName,
            arguments: restaurant);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 130,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(restaurant.pictureId),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 165,
                    ),
                    child: Text(
                      restaurant.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 8,
                          right: 8,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: secondaryColor,
                          size: 16,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            restaurant.city,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 8),
                          child: ratingStars(restaurant.rating),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
