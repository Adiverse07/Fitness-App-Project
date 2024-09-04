import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/color_extension.dart';
import '../../common_widget/meal_category_cell.dart';
import '../../common_widget/meal_recommed_cell.dart';
import '../../common_widget/popular_meal_row.dart';
import '../../common_widget/today_meal_row.dart';
import 'food_info_details_view.dart';
import 'model.dart';
import 'resultpage.dart';

class MealFoodDetailsView extends StatefulWidget {
  final Map eObj;
  const MealFoodDetailsView({Key? key, required this.eObj}) : super(key: key);

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  TextEditingController txtSearch = TextEditingController();
  List<String> _recentSearches = [];

  Future<List<Map<String, dynamic>>> getRecipe(String query) async {
    List<Map<String, dynamic>> recipesData = [];

    try {
      String url =
          "https://api.edamam.com/api/recipes/v2?type=public&q=$query&app_id=de1e21a2&app_key=%20014f091ca101b377bdb2d0a9a9ecb83c";
      var response = await http.get(Uri.parse(url));
      Map data = jsonDecode(response.body);

      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel.fromMap(element["recipe"]);
        Map<String, dynamic> recipeData = {
          'applabel': recipeModel.applabel,
          'appcalories': recipeModel.appcalories,
          'appProtein': recipeModel.appProtein,
          'appimgUrl': recipeModel.appimgUrl,
          'appurl': recipeModel.appurl
        };
        recipesData.add(recipeData);
      });
    } catch (e) {
      print('Error fetching recipe: $e');
    }

    return recipesData;
  }

  void _addToRecentSearches(String searchText) {

    setState(() {
      if (!_recentSearches.contains(searchText)) {
        _recentSearches.insert(0, searchText);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipe("varan bhaat");
  }

  List categoryArr = [
    {"name": "Salad", "image": "assets/images/c_1.png"},
    {"name": "Cake", "image": "assets/images/c_2.png"},
    {"name": "Pie", "image": "assets/images/c_3.png"},
    {"name": "Smoothies", "image": "assets/images/c_4.png"},
    {"name": "Chicken", "image": "assets/images/chicken.png"},
    {"name": "Coffee", "image": "assets/images/coffee.png"},
    {"name": "Eggs", "image": "assets/images/eggs.png"},
    {"name": "Canai Bread", "image": "assets/images/m_4.png"},
  ];

  List popularArr = [
    {
      "name": "Blueberry Pancake",
      "image": "assets/images/f_1.png",
      "b_image": "assets/images/pancake_1.png",
      "size": "Medium",
      "time": "30mins",
      "kcal": "230kCal"
    },
    {
      "name": "Salmon Nigiri",
      "image": "assets/images/f_2.png",
      "b_image": "assets/images/nigiri.png",
      "size": "Medium",
      "time": "20mins",
      "kcal": "120kCal"
    },
  ];

  List recommendArr = [
    {
      "name": "Milk",
      "image": "assets/images/m_2.png",
      "size": "Easy",
      "time": "30mins",
      "kcal": "180kCal"
    },
    {
      "name": "Canai Bread",
      "image": "assets/images/m_4.png",
      "size": "Easy",
      "time": "20mins",
      "kcal": "230kCal"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tcolor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Tcolor.lightgray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/images/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          widget.eObj["name"].toString(),
          style: TextStyle(
              color: Tcolor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                _recentSearches.clear();
              });
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Tcolor.lightgray,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.clear_all),
            ),
          )
        ],
      ),
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: Tcolor.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1))
                  ]),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: txtSearch,
                              decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                prefixIcon: Image.asset(
                                  "assets/images/search.png",
                                  width: 25,
                                  height: 25,
                                ),
                                hintText: "Search Pancake",
                              ),
                              onSubmitted: (value) async {
                                _addToRecentSearches(value);
                                List<Map<String, dynamic>> recipesData =
                                await getRecipe(value);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ResultPage(recipesData: recipesData),
                                  ),
                                );
                              },
                            ),
                            _recentSearches.isEmpty
                                ? SizedBox.shrink()
                                : Wrap(
                              spacing: 8,
                              children: [
                                ..._recentSearches.map(
                                      (searchItem) => InputChip(
                                    label: Text(searchItem),
                                    onPressed: () {
                                      setState(() {
                                        txtSearch.text = searchItem;
                                      });
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _recentSearches.clear();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 1,
                        height: 25,
                        color: Tcolor.gray.withOpacity(0.3),
                      ),
                      // InkWell(
                      //   onTap: () {},
                      //   child: Image.asset(
                      //     "assets/images/Filter.png",
                      //     width: 25,
                      //     height: 25,
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryArr.length,
                  itemBuilder: (context, index) {
                    var cObj = categoryArr[index] as Map? ?? {};
                    return GestureDetector(
                      child: MealCategoryCell(
                        cObj: cObj,
                        index: index,
                      ),
                      onTap: () async {
                        String categoryName =
                        categoryArr[index]["name"].toString();
                        List<Map<String, dynamic>> recipesData =
                        await getRecipe(categoryName);
                        _addToRecentSearches(categoryName);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultPage(
                              recipesData: recipesData,
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Recommendation\nfor Diet",
                style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: media.width * 0.6,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendArr.length,
                  itemBuilder: (context, index) {
                    var fObj = recommendArr[index] as Map? ?? {};
                    return GestureDetector(
                      child: MealRecommendCell(
                        fObj: fObj,
                        index: index,
                        recommendArr: recommendArr,
                        getRecipe: getRecipe,
                        addToRecentSearches: _addToRecentSearches,
                      ),
                      onTap: () async {
                        String recommendName = recommendArr[index]["name"].toString();
                        List<Map<String, dynamic>> recipesData = await getRecipe(recommendName);
                        _addToRecentSearches(recommendName);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultPage(
                              recipesData: recipesData,
                            ),
                          ),
                        );
                      },
                    );

                  }),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Popular",
                style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: popularArr.length,
                itemBuilder: (context, index) {
                  var fObj = popularArr[index] as Map? ?? {};
                  return PopularMealRow(mObj: fObj,index: index,
                    recommendArr: popularArr,
                    getRecipe: getRecipe,
                    addToRecentSearches: _addToRecentSearches
                  );
                }),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
