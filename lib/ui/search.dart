import 'package:flutter/material.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/models/restaurant.dart';
import 'package:dicoding_project_restaurant_app/utils/ratings.dart';
import 'package:dicoding_project_restaurant_app/utils/custom_error_exception.dart';
import 'package:dicoding_project_restaurant_app/ui/restaurant_detail.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<String> _loadData() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/data/local_restaurant.json');
  }

  List<RestaurantElement> _allRestaurants = [];
  Future<List<RestaurantElement>> _initializeData() async {
    final String data = await _loadData();
    final List<RestaurantElement> restaurants =
        restaurantFromJson(data).restaurants;
    _allRestaurants = restaurants;
    return restaurants;
  }

  List<RestaurantElement> _foundRestaurants = [];
  @override
  initState() {
    _initializeData();
    _foundRestaurants = _allRestaurants;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<RestaurantElement> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allRestaurants;
    } else {
      results = _allRestaurants
          .where((restaurant) => restaurant.name
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundRestaurants = results;
    });
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
              child: _foundRestaurants.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundRestaurants.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          RestaurantElement restaurant = RestaurantElement(
                              id: _foundRestaurants[index].id,
                              name: _foundRestaurants[index].name,
                              description: _foundRestaurants[index].description,
                              pictureId: _foundRestaurants[index].pictureId,
                              city: _foundRestaurants[index].city,
                              rating: _foundRestaurants[index].rating,
                              menus: _foundRestaurants[index].menus);
                          Navigator.pushNamed(
                              context, RestaurantDetail.routeName,
                              arguments: restaurant);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              Hero(
                                tag: _foundRestaurants[index].pictureId,
                                child: Container(
                                  width: 130,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          _foundRestaurants[index].pictureId),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 165,
                                      ),
                                      child: Text(
                                        _foundRestaurants[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                            top: 8,
                                            right: 8,
                                          ),
                                          child: Icon(
                                            Icons.location_on,
                                            color: secondaryColor,
                                            size: 16,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              _foundRestaurants[index].city,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
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
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: ratingStars(
                                                _foundRestaurants[index]
                                                    .rating),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const CustomErrorException(
                      icon: Icon(
                        Icons.warning_rounded,
                        size: 50,
                        color: secondaryColor,
                      ),
                      message: "Restaurant not found",
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
