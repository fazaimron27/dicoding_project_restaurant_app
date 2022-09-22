import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/data/api/api_service.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant_search.dart';
import 'package:dicoding_project_restaurant_app/widgets/card_search.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = '';

  void _runFilter(String enteredKeyword) {
    setState(() {
      query = enteredKeyword;
    });
  }

  Future<RestaurantSearch> _searchRestaurants() async {
    return await ApiService().searchRestaurant(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Search",
              style: TextStyle(fontSize: 32, color: primaryColor),
            ),
            Text(
              "Find your favorite restaurant",
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
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                decoration: const InputDecoration(
                  hintText: "Search",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                onChanged: (value) => _runFilter(value)),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: FutureBuilder(
                future: _searchRestaurants(),
                builder: ((context, AsyncSnapshot<RestaurantSearch> snapshot) {
                  var state = snapshot.connectionState;
                  if (state != ConnectionState.done) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: secondaryColor,
                    ));
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data?.founded == 0) {
                        return const CustomErrorException(
                          icon: Icon(
                            Icons.error_outline,
                            size: 50,
                            color: secondaryColor,
                          ),
                          message: 'No restaurant found',
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.restaurants.length,
                          itemBuilder: (context, index) {
                            var restaurant = snapshot.data?.restaurants[index];
                            return CardSearch(restaurant: restaurant!);
                          },
                        );
                      }
                    } else if (snapshot.hasError) {
                      return const CustomErrorException(
                        icon: Icon(
                          Icons.looks,
                          size: 50,
                          color: secondaryColor,
                        ),
                        message: 'Find the restaurant you want',
                      );
                    } else {
                      return const CustomErrorException(
                        icon: Icon(
                          Icons.error_outline,
                          size: 50,
                          color: secondaryColor,
                        ),
                        message: 'Something went wrong',
                      );
                    }
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
