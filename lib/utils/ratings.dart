import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';

// convert rating to stars
Widget ratingStars(double rating) {
  final stars = <Widget>[];
  const int starCount = 5;
  for (var i = 0; i < starCount; i++) {
    if (i >= rating) {
      stars.add(const Icon(
        Icons.star_border,
        color: secondaryColor,
        size: 16,
      ));
    } else if (i > rating - 1 && i < rating) {
      stars.add(const Icon(
        Icons.star_half,
        color: secondaryColor,
        size: 16,
      ));
    } else {
      stars.add(const Icon(
        Icons.star,
        color: secondaryColor,
        size: 16,
      ));
    }
  }

  return Row(
    children: stars,
  );
}
