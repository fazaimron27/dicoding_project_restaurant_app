import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_detail.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final String id;

  const RestaurantDetailPage({Key? key, required this.id}) : super(key: key);

  Future<RestaurantDetail> _restaurantDetail() async {
    return await ApiService().getRestaurantById(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _restaurantDetail(),
      builder: (context, AsyncSnapshot<RestaurantDetail> snapshot) {
        var state = snapshot.connectionState;
        if (state != ConnectionState.done) {
          return const Center(
              child: CircularProgressIndicator(
            color: secondaryColor,
          ));
        } else {
          if (snapshot.hasData) {
            return _buildDetailRestaurant(snapshot, context);
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomErrorException(
                    icon: const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: secondaryColor,
                    ),
                    message: snapshot.error.toString().split('Exception: ')[1],
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: secondaryColor,
                      side: const BorderSide(color: secondaryColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        color: secondaryColor,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomErrorException(
                    icon: Icon(
                      Icons.error_outline,
                      size: 50,
                      color: secondaryColor,
                    ),
                    message: 'Something went wrong',
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: secondaryColor,
                      side: const BorderSide(color: secondaryColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        color: secondaryColor,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        }
      },
    );
  }

  Scaffold _buildDetailRestaurant(
      AsyncSnapshot<RestaurantDetail> snapshot, BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: snapshot.data!.restaurant.pictureId,
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://restaurant-api.dicoding.dev/images/large/${snapshot.data!.restaurant.pictureId}'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                    ),
                    child: Text(
                      snapshot.data!.restaurant.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 3,
                          right: 8,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            snapshot.data!.restaurant.city,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 3,
                          right: 8,
                          left: 15,
                        ),
                        child: Icon(
                          Icons.home,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              snapshot.data!.restaurant.address,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 3,
                          right: 8,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: secondaryColor,
                          size: 16,
                        ),
                      ),
                      Row(
                        children: snapshot.data!.restaurant.categories
                            .map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              category.name +
                                  (category ==
                                          snapshot
                                              .data!.restaurant.categories.last
                                      ? ''
                                      : ', '),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 3,
                          right: 8,
                          left: 15,
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            snapshot.data!.restaurant.rating.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                    child: Text(
                      "Description",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 3,
                    ),
                    child: Text(
                      snapshot.data!.restaurant.description,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                    child: Text(
                      "Menus",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 3,
                    ),
                    child: Text(
                      "Foods",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          snapshot.data!.restaurant.menus.foods.map((food) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/food.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Text(food.name),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 3,
                    ),
                    child: Text(
                      "Drinks",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          snapshot.data!.restaurant.menus.drinks.map((drink) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/drink.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Text(drink.name),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Customer Reviews
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                    child: Text(
                      "Customer Reviews",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 500,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.restaurant.customerReviews
                            .map((review) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://ui-avatars.com/api/?background=736CED&color=fff&name=${review.name}'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              review.name,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              review.date,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        review.review,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        onPressed: () {
          // Respond to button press
        },
        icon: const Icon(Icons.create),
        label: const Text('Write Review'),
      ),
    );
  }
}
