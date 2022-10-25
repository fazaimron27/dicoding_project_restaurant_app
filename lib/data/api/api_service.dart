import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dicoding_project_restaurant_app/data/models/restaurant.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_detail.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_search.dart';
import 'package:dicoding_project_restaurant_app/data/models/review_response.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<RestaurantsResult> getAllRestaurants() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<RestaurantsResult> getRandomRestaurant() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));

    if (response.statusCode == 200) {
      final result = RestaurantsResult.fromJson(json.decode(response.body));
      result.restaurants.shuffle();
      return result;
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<RestaurantDetail> getRestaurantById(id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  Future<ReviewResponse> getReviewById(id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return ReviewResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load review');
    }
  }

  Future<RestaurantSearch> searchRestaurant(query) async {
    final response = await http.get(Uri.parse("${_baseUrl}search?q=$query"));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurant');
    }
  }

  Future<ReviewResponse> postReview(id, name, review) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}review"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"id": id, "name": name, "review": review},
    );
    if (ReviewResponse.fromJson(json.decode(response.body)).error) {
      throw Exception('Failed to post review');
    } else {
      return ReviewResponse.fromJson(json.decode(response.body));
    }
  }
}
