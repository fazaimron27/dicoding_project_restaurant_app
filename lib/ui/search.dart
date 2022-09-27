import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/widgets/card_search.dart';
import 'package:dicoding_project_restaurant_app/provider/search_provider.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

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
            Consumer<SearchProvider>(
              builder: (context, state, _) => TextField(
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
                onChanged: (value) => state.runSearch(value),
              ),
            ),
            Expanded(
              child: Consumer<SearchProvider>(builder: (context, state, _) {
                if (state.state == ResultState.loading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: secondaryColor,
                  ));
                } else if (state.state == ResultState.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.result.restaurants.length,
                    itemBuilder: (context, index) {
                      var restaurant = state.result.restaurants[index];
                      return CardSearch(restaurant: restaurant);
                    },
                  );
                } else if (state.state == ResultState.noData) {
                  return const CustomErrorException(
                    icon: Icon(
                      Icons.error_outline,
                      size: 50,
                      color: secondaryColor,
                    ),
                    message: 'No restaurant found',
                  );
                } else {
                  return const CustomErrorException(
                    icon: Icon(
                      Icons.looks,
                      size: 50,
                      color: secondaryColor,
                    ),
                    message: 'Find the restaurant you want',
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
