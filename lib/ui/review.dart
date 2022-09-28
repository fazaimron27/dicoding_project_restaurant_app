import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/utils/string_utils.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';
import 'package:dicoding_project_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_project_restaurant_app/utils/result_state.dart';

class Review extends StatelessWidget {
  static const routeName = '/review';

  final String id;

  const Review({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: secondaryColor,
          ));
        } else if (state.state == ResultState.hasData) {
          return _buildReview(state, context);
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

  Scaffold _buildHasError(
      RestaurantDetailProvider state, BuildContext context) {
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

  Scaffold _buildReview(RestaurantDetailProvider state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        foregroundColor: primaryColor,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Customer Reviews",
              style: TextStyle(fontSize: 32, color: primaryColor),
            ),
            Text(
              "What they say about us!",
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
      body: ListView.builder(
        itemCount: state.result.restaurant.customerReviews.length,
        itemBuilder: (context, index) {
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
                            StringUtils.getAvatarUrl(state
                                .result.restaurant.customerReviews[index].name),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.result.restaurant.customerReviews[index]
                                  .name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              state.result.restaurant.customerReviews[index]
                                  .date,
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
                        state.result.restaurant.customerReviews[index].review,
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
        },
      ),
    );
  }
}
