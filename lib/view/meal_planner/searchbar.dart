import 'package:flutter/material.dart';

import '../../common/color_extension.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addToRecentSearches(String searchText) {
    setState(() {
      if (!_recentSearches.contains(searchText)) {
        _recentSearches.insert(0, searchText);
      }
    });
  }

  void _onSubmitted(String searchText) {
    _addToRecentSearches(searchText);
    // Perform search or any other action here
  }

  void _onRecentSearchSelected(String searchText) {
    _searchController.text = searchText;
    _addToRecentSearches(searchText); // Move selected search to top
    // Perform search or any other action here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search',
          ),
          onSubmitted: _onSubmitted,
        ),
      ),
      body: ListView(
        children: _recentSearches.map((searchText) {
          return ListTile(
            title: Text(searchText),
            onTap: () => _onRecentSearchSelected(searchText),
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Tcolor.primaryColor1,
        fontFamily: "Poppins",
      ),
      home: SearchPage(),
    );
  }
}


