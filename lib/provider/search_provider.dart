import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dicoding_project_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_search.dart';
import 'package:dicoding_project_restaurant_app/utils/result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;
  String query;

  SearchProvider({required this.apiService, this.query = ''}) {
    _searchRestaurant(query);
  }

  late RestaurantSearch _restaurantSearch;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantSearch get result => _restaurantSearch;

  ResultState get state => _state;

  runSearch(String query) {
    this.query = query;
    _searchRestaurant(this.query);
    notifyListeners();
  }

  Future<dynamic> _searchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant =
          await apiService.searchRestaurant(http.Client(), query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Restaurants Not Found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantSearch = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
