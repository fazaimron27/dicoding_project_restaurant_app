import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/common/navigation.dart';
import 'package:dicoding_project_restaurant_app/ui/review.dart';
import 'package:dicoding_project_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_project_restaurant_app/utils/string_utils.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';
import 'package:dicoding_project_restaurant_app/utils/result_state.dart';
import 'package:dicoding_project_restaurant_app/provider/review_provider.dart'
    as review_provider;
import 'package:dicoding_project_restaurant_app/provider/restaurant_detail_provider.dart'
    as restaurant_detai_provider;

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final String id;

  const RestaurantDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<restaurant_detai_provider.RestaurantDetailProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: secondaryColor,
          ));
        } else if (state.state == ResultState.hasData) {
          return _buildDetailRestaurant(state, context);
        } else if (state.state == ResultState.noData) {
          return _buildHasError(state, context);
        } else {
          return _buildError(context);
        }
      },
    );
  }

  Scaffold _buildError(BuildContext context) {
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
              Navigation.back();
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

  Scaffold _buildHasError(
      restaurant_detai_provider.RestaurantDetailProvider state,
      BuildContext context) {
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
            message: state.message,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: secondaryColor,
              side: const BorderSide(color: secondaryColor),
            ),
            onPressed: () {
              Navigation.back();
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

  Scaffold _buildDetailRestaurant(
    restaurant_detai_provider.RestaurantDetailProvider state,
    BuildContext context,
  ) {
    TextEditingController nameController = TextEditingController();
    TextEditingController reviewController = TextEditingController();
    String name = '';
    String review = '';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: state.result.restaurant.pictureId,
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              StringUtils.getImgUrl(
                                  state.result.restaurant.pictureId, 'large'),
                            ),
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
                                  Navigation.back();
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
                      state.result.restaurant.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
                          size: 14,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            state.result.restaurant.city,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
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
                          size: 14,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              state.result.restaurant.address,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
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
                          Icons.category,
                          color: secondaryColor,
                          size: 14,
                        ),
                      ),
                      Row(
                        children:
                            state.result.restaurant.categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              category.name +
                                  (category ==
                                          state
                                              .result.restaurant.categories.last
                                      ? ''
                                      : ', '),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
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
                          size: 14,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            state.result.restaurant.rating.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
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
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 3,
                    ),
                    child: Text(
                      state.result.restaurant.description,
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
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.result.restaurant.menus.foods.map((food) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/food.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                  ),
                                ),
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
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          state.result.restaurant.menus.drinks.map((drink) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/drink.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Text(
                                  drink.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigation.intentWithData(Review.routeName,
                                    state.result.restaurant.id);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: secondaryColor,
                              ),
                              child: const Text(
                                "See Reviews",
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _buildDialogReview(context, nameController,
                                    name, reviewController, review);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: secondaryColor,
                              ),
                              child: const Text(
                                "Write Review",
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildDialogReview(
      BuildContext context,
      TextEditingController nameController,
      String name,
      TextEditingController reviewController,
      String review) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'John Doe',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (value) => name = value,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Review',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: reviewController,
                    decoration: const InputDecoration(
                      hintText: 'Write your review',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (value) => review = value,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigation.back();
                  nameController.clear();
                  reviewController.clear();
                },
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  if (name.isEmpty || review.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Name and Review cannot be empty'),
                      ),
                    );
                  } else {
                    review_provider.ReviewProvider(apiService: ApiService())
                        .submitReview(id, name, review)
                        .then((value) {
                      if (value.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to submit review'),
                          ),
                        );
                      } else {
                        Navigation.back();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Review submitted'),
                          ),
                        );
                        nameController.clear();
                        reviewController.clear();
                      }
                    });
                  }
                },
                child:
                    const Text('Send', style: TextStyle(color: secondaryColor)),
              ),
            ],
          ),
        );
      },
    );
  }
}
