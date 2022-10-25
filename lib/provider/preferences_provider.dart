import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyRecommendationPreferences();
  }

  bool _isDailyRecommendationActive = false;
  bool get isDailyRecommendationActive => _isDailyRecommendationActive;

  void _getDailyRecommendationPreferences() async {
    _isDailyRecommendationActive =
        await preferencesHelper.isDailyRecommendationActive;
    notifyListeners();
  }

  void enableDailyRecommendation(bool value) {
    preferencesHelper.setDailyRecommendation(value);
    _getDailyRecommendationPreferences();
  }
}
