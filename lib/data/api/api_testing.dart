import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dicoding_project_restaurant_app/data/models/restaurant.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_detail.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_search.dart';

class ApiTesting {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  static Future<RestaurantsResult> getAllRestaurants(http.Client client) async {
    final response = await client.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  static Future<RestaurantDetail> getRestaurantById(
      http.Client client, id) async {
    final response = await client.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  static Future<RestaurantSearch> searchRestaurant(
      http.Client client, query) async {
    final response = await client.get(Uri.parse("${_baseUrl}search?q=$query"));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurant');
    }
  }
}
