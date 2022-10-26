import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dicoding_project_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_project_restaurant_app/data/models/review_response.dart';
import 'package:dicoding_project_restaurant_app/utils/result_state.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  ReviewProvider({required this.apiService});

  late ReviewResponse _reviewResponse;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  ReviewResponse get result => _reviewResponse;

  ResultState get state => _state;

  Future<dynamic> submitReview(String id, String name, String review) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final reviewResponse =
          await apiService.postReview(http.Client(), id, name, review);
      if (reviewResponse.error) {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Failed to post review';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _reviewResponse = reviewResponse;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
