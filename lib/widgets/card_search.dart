import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/navigation.dart';
import 'package:dicoding_project_restaurant_app/utils/ratings.dart';
import 'package:dicoding_project_restaurant_app/utils/string_utils.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_search.dart';
import 'package:dicoding_project_restaurant_app/ui/restaurant_detail.dart';

class CardSearch extends StatelessWidget {
  final Restaurant restaurant;
  const CardSearch({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigation.intentWithData(
            RestaurantDetailPage.routeName, restaurant.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Hero(
              tag: restaurant.pictureId,
              child: Container(
                width: 115,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      StringUtils.getImgUrl(restaurant.pictureId, 'small'),
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 165,
                      ),
                      child: Text(
                        restaurant.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 8,
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
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              restaurant.city,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: ratingStars(restaurant.rating),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
