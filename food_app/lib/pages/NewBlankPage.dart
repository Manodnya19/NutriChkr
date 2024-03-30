import 'package:flutter/material.dart';
import 'package:food_app/widgets/background-image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:progress_indicators/progress_indicators.dart';

class NewBlankPage extends StatefulWidget {
  final String prediction;

  // Constructor with a named parameter 'prediction'
  NewBlankPage({required this.prediction});

  @override
  _NewBlankPageState createState() => _NewBlankPageState();
}

class _NewBlankPageState extends State<NewBlankPage> {
  bool isButtonVisible = true;
  Map<String, dynamic>? nutrients;
  TextEditingController searchController = TextEditingController();
  int _currentIndex = 0;

  String get prediction => widget.prediction;
  @override
  void initState() {
    super.initState();
    // Call fetchDataFromAPI method with the prediction value on page load
    fetchDataFromAPI(prediction);
  }

  // Map to transform API nutrient names to display names
  static const Map<String, String> nutrientDisplayNames = {
    'ENERC_KCAL': 'Calories',
    'FAT': 'Total Fat',
    'FASAT': 'Saturated Fat',
    'FATRN': 'Trans Fat',
    'CHOLE': 'Cholesterol',
    'NA': 'Sodium',
    'CHOCDF': 'Total Carbohydrate',
    'FIBTG': 'Dietary Fiber',
    'SUGAR': 'Total Sugars',
    'PROCNT': 'Protein',
    'VITD': 'Vitamin D',
    'CA': 'Calcium',
    'FE': 'Iron',
    'K': 'Potassium',
    'VITC': 'Vitamin C',
  };

  Future<void> fetchDataFromAPI(String enteredFood) async {
    setState(() {
      isButtonVisible = false;
    });

    final app_id = '3632e0eb';

    final apiUrl = Uri.parse(
        'https://api.edamam.com/api/food-database/v2/parser?app_id=$app_id&app_key=e617488ee53860984e37cd7ca286e112&nutrition-type=cooking&ingr=$enteredFood');

    try {
      final response = await http.get(apiUrl);

      print('API Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('hints') &&
            jsonResponse['hints'].isNotEmpty) {
          final List<dynamic> hints = jsonResponse['hints'];
          final Map<String, dynamic> foodData = hints[0]['food'];

          final String label = foodData['label'];
          final Map<String, dynamic> foodNutrients = foodData['nutrients'];

          final Map<String, dynamic> transformedNutrients = {};
          foodNutrients.forEach((key, value) {
            final String displayName = nutrientDisplayNames[key] ?? key;
            transformedNutrients[displayName] = value;
          });

          setState(() {
            nutrients = transformedNutrients;
          });

          print('Nutrients for $label: $nutrients');
        } else {
          setState(() {
            nutrients = null;
          });

          print('Error: Food not found or nutrients not available.');
        }
      } else {
        setState(() {
          nutrients = null;
        });

        print(
            'Error: Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      setState(() {
        nutrients = null;
      });

      print('HTTP Client Exception: $e');
    } catch (e) {
      setState(() {
        nutrients = null;
      });

      print('Exception: $e');
    }
  }

  List<PieChartSectionData> getTopThreeNutrients() {
    if (nutrients == null) {
      // Return empty list if nutrients data is not available
      return [];
    }

    // Extract nutrient values from the fetched data
    double protein = nutrients!['Protein'] ?? 0.0;
    double totalFat = nutrients!['Total Fat'] ?? 0.0;
    double carbohydrates = nutrients!['Total Carbohydrate'] ?? 0.0;
    double fiber = nutrients!['Dietary Fiber'] ?? 0.0;

    List<Map<String, dynamic>> nutrientsList = [
      {'name': 'Protein', 'value': protein},
      {'name': 'Fat', 'value': totalFat},
      {'name': 'Carbohydrates', 'value': carbohydrates},
      {'name': 'Dietary Fiber', 'value': fiber},
    ];

    // Sort the list based on nutrient values in descending order
    nutrientsList.sort((a, b) => b['value'].compareTo(a['value']));

    // Get the top three nutrients
    nutrientsList = nutrientsList.take(3).toList();

    // Map the nutrients for the pie chart
    return List.generate(nutrientsList.length, (index) {
      return PieChartSectionData(
        color: getColor(index),
        value: nutrientsList[index]['value'],
        title:
            '${nutrientsList[index]['name']}: ${nutrientsList[index]['value'].toStringAsFixed(2)}g',
        radius: 60.0,
        titleStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    });
  }

  Color getColor(int index) {
    List<Color> colors = [Colors.blue, Colors.yellow, Colors.red, Colors.green];
    if (index < colors.length) {
      return colors[index];
    } else {
      return Colors.grey; // Fallback color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Information'),
        backgroundColor: Color.fromARGB(255, 73, 145, 76),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  nutrients != null
                      ? Column(
                          children: [
                            Text(
                              "Are you planning to eat " +
                                  prediction +
                                  "? \uD83D\uDE0B",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Text("Breakdown of nutritious content in " +
                                prediction),
                            SizedBox(height: 20),
                            Container(
                              height:
                                  200, // Specify the height for the PieChart
                              child: PieChart(
                                PieChartData(
                                  // pieTouchData: PieTouchData(
                                  //     touchCallback: (event, response) {}),
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 40,
                                  sections: getTopThreeNutrients()
                                      .map((section) => PieChartSectionData(
                                            color: section.color,
                                            value: double.parse(
                                              section.value.toStringAsFixed(2),
                                            ),
                                            radius: section.radius,
                                          ))
                                      .toList(),
                                ),
                                swapAnimationDuration:
                                    Duration(milliseconds: 360),
                                swapAnimationCurve: Curves.linear,
                              ),
                            ),

                            SizedBox(height: 20),
                            // Display the names of the top three nutrients with their colors
                            SizedBox(
                              height: 80,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          20), // Add padding to the left and right
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              getTopThreeNutrients().length,
                                          itemBuilder: (context, index) {
                                            final nutrient =
                                                getTopThreeNutrients()[index];
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    color: nutrient.color,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    nutrient.title.split(":")[
                                                        0], // Display only the nutrient name
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust the value for the desired curve
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nutrition Facts',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Serving Size (84 Gram)',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    SizedBox(height: 4),
                                    Divider(
                                      // Add a Divider widget here
                                      color: const Color.fromARGB(255, 190, 190,
                                          190), // Set the color of the divider to grey
                                      thickness:
                                          6.0, // Set the thickness of the divider
                                      height:
                                          20.0, // Set the height of the divider
                                    ),
                                    Text(
                                      'Amount Per 100 Grams',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: nutrients!.entries.map((entry) {
                                        if (entry.key != 'Calories') {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  entry.key,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${double.parse(entry.value.toString()).toStringAsFixed(2)}g',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          // For Calories, increase font size and remove 'g'
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  entry.key,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        25, // Set the desired font size for Calories
                                                  ),
                                                ),
                                                Text(
                                                  double.parse(entry.value
                                                          .toString())
                                                      .toStringAsFixed(0),
                                                  style: TextStyle(
                                                      fontSize: 24.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(), // Show SizedBox if nutrients data is null
                ],
              ),
              if (nutrients == null)
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 120.0), // Adjust the vertical padding
                  child: Center(
                    // Center the loading indicator
                    child: JumpingDotsProgressIndicator(
                      fontSize: 30.0,
                      numberOfDots: 5,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
