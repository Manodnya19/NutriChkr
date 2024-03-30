import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:progress_indicators/progress_indicators.dart';

class SearchRecipe extends StatefulWidget {
  final String recipeId;

  SearchRecipe({required this.recipeId});

  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  Map<String, dynamic> _recipeInfo = {};

  @override
  void initState() {
    super.initState();
    _fetchRecipeInfo();
  }

  Future<void> _fetchRecipeInfo() async {
    String url = "https://tasty.p.rapidapi.com/recipes/get-more-info";

    Map<String, String> queryParameters = {
      "id": widget.recipeId,
    };

    Map<String, String> headers = {
      'X-RapidAPI-Key': '98a7b86f4fmshbda6505ec474378p180a52jsn5a24106793f0',
      'X-RapidAPI-Host': 'tasty.p.rapidapi.com'
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          _recipeInfo = jsonDecode(response.body);
        });
      } else {
        print(
            'Failed to fetch recipe info. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe Details',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 49, 102, 49),
      ),
      body: _recipeInfo.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    child: Image.network(
                      _recipeInfo['thumbnail_url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Text(
                  //     'Recipe Details: $_recipeInfo',
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      _recipeInfo['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  RecipeDetails(sections: _recipeInfo['sections']),
                  SizedBox(height: 20),
                  RecipeInstructions(instructions: _recipeInfo['instructions']),
                ],
              ),
            )
          : Center(
              child: JumpingDotsProgressIndicator(
                color: Theme.of(context).primaryColor,
                fontSize: 30.0,
                numberOfDots: 5,
              ),
            ),
    );
  }
}

class RecipeDetails extends StatelessWidget {
  final List<dynamic> sections;

  RecipeDetails({required this.sections});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Ingredients:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(8.0), // Add padding to the container
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                for (var section in sections)
                  ...section['components'].map<Widget>((component) {
                    if (component.containsKey('raw_text')) {
                      return ListTile(
                        title: Text(component['raw_text']),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeInstructions extends StatelessWidget {
  final List<dynamic> instructions;

  RecipeInstructions({required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          //padding: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
          child: Text(
            'Instructions:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0), // Padding around the box
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                // Display the display text from each instruction
                for (var instruction in instructions)
                  if (instruction.containsKey('display_text'))
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0), // Padding for each list tile
                      leading: CircleAvatar(
                        backgroundColor: Colors.green, // Change color to green
                        child: Text(
                          '${instruction['position']}',
                          style: TextStyle(color: Colors.white), // Text color
                        ),
                      ),
                      title: Text(instruction['display_text']),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
