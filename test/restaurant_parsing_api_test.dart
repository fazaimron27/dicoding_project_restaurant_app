import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dicoding_project_restaurant_app/data/api/api_testing.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_detail.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_search.dart';

void main() {
  group(
    'Restaurant API Testing',
    () {
      /// Test Case Get List Restaurant
      test(
        'Testing API get All Restaurant',
        () async {
          final client = MockClient(
            (request) async {
              final response = {
                "error": false,
                "message": "success",
                "count": 20,
                "restaurants": []
              };
              return http.Response(json.encode(response), 200);
            },
          );

          expect(
            await ApiTesting.getAllRestaurants(client),
            isA<RestaurantsResult>(),
          );
        },
      );

      /// Test Case Get Detail Restaurant
      test(
        'Testing API get Restaurant By Id',
        () async {
          final client = MockClient(
            (request) async {
              final response = {
                "error": false,
                "message": "success",
                "restaurant": {
                  "id": "",
                  "name": "",
                  "description": "",
                  "city": "",
                  "address": "",
                  "pictureId": "",
                  "categories": [],
                  "menus": {"foods": [], "drinks": []},
                  "rating": 1.0,
                  "customerReviews": []
                }
              };
              return http.Response(json.encode(response), 200);
            },
          );

          expect(
            await ApiTesting.getRestaurantById(
              client,
              'Restaurant Id Example',
            ),
            isA<RestaurantDetail>(),
          );
        },
      );

      /// Test Case Get Restaurant By Search
      test(
        'Testing API Search Restaurant',
        () async {
          final client = MockClient(
            (request) async {
              final response = {
                "error": false,
                "founded": 1,
                "restaurants": []
              };
              return http.Response(json.encode(response), 200);
            },
          );

          expect(
            await ApiTesting.searchRestaurant(
              client,
              'Restaurant Name Example',
            ),
            isA<RestaurantSearch>(),
          );
        },
      );
    },
  );
}
