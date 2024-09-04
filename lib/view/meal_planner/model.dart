import 'dart:ffi';

class RecipeModel{
  late String applabel;
  late String appimgUrl;
  late double appcalories;
  late double appProtein;
  late String appurl;

  RecipeModel(
  {
    this.applabel ="templabel",
    this.appimgUrl="tempimgurl",
    this.appcalories = 0.0,
    this.appurl = "tempappurl",
    this.appProtein = 0.0
});

  factory RecipeModel.fromMap(Map recipe){

    // for accessing protein
    Map totalNutrients = recipe["totalNutrients"];

    return RecipeModel(
      applabel: recipe["label"],
      appimgUrl: recipe["image"],
      appcalories: recipe["calories"],
      appurl: recipe["url"],
        appProtein: totalNutrients["PROCNT"]["quantity"]
    );
  }

}