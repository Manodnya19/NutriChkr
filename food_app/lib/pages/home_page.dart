import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:food_app/pages/ImageConfirmationPage.dart';
import 'package:food_app/pages/NewBlankPage.dart';
import 'package:food_app/pages/bottom_bar.dart';
import 'package:food_app/pages/login_page.dart';
import 'package:food_app/pages/mlmodel.dart';
import 'package:food_app/pages/nav_bar.dart';
import 'package:food_app/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/pages/recepie.dart';
import 'package:food_app/widgets/background-image.dart';
import 'package:food_app/widgets/food.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class MyApp extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final MLModel mlModel = MLModel();
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _pickImageFromCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      runModelOnImage(context, image);
    }
  }

  void runModelOnImage(BuildContext context, File image) async {
    // Load the ML model if not already loaded
    print('before model load function!!!!!!!!!!!!!!!!!!!!!!!!!');
    await Tflite.loadModel(
      model: "assets/images/model1.tflite",
      labels: "assets/images/classes.txt",
    );
    print('model loaded!!!!!!!!!!!!!!!!!!!!!!!!!');

    // Run the ML model on the captured image
    await mlModel.detectimage(image);
    String labelName = mlModel.v.split(',')[2];
    String finalName = labelName.split(' ')[2];

// Removing unnecessary characters
    finalName = finalName.replaceAll(']', ''); // Remove ']' character
    finalName = finalName.replaceAll('}', '');

// Updating finalName to store only 'samosa'
    finalName = finalName.replaceAll('_', ' ');

    // Navigate to the new blank page directly with the prediction result
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NewBlankPage(prediction: finalName),
    ));
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      runModelOnImage(context, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    String prediction = '';

    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage(),
      },
      home: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: NavBar(
          auth: auth,
          displayName: user?.displayName ?? 'Guest',
          email: user?.email ?? '',
        ),
        appBar: AppBar(
          title: Text(
            'NutriChkr',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 49, 102, 49),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.camera),
          //     onPressed: () {
          //       _pickImageFromCamera(context);
          //     },
          //   ),
          //   IconButton(
          //     icon: Icon(Icons.photo),
          //     onPressed: () {
          //       _pickImageFromGallery(context);
          //     },
          //   ),
          // ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            //const BackgroundImage(),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Color.fromARGB(255, 243, 243, 243),
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 49, 102, 49),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Food Lookup',
                                    prefixIcon: Icon(Icons.search),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        prediction = _searchController
                                            .text; // Get value from search bar
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => NewBlankPage(
                                              prediction:
                                                  prediction), // Navigate to the new blank page
                                        ));
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 49, 102, 49),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ), // Add some space between "Welcome!" and the first container
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Capture or select an image of your food item to get nutritional information instantly.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 49, 102, 49),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 131, 185, 131),
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 25),
                                      ),
                                      onPressed: () async {
                                        await _pickImageFromCamera(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.camera),
                                          SizedBox(width: 4),
                                          Text(
                                            'Camera',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 131, 185, 131),
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 25),
                                      ),
                                      onPressed: () async {
                                        await _pickImageFromGallery(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.photo),
                                          SizedBox(width: 4),
                                          Text(
                                            'Gallery',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                            // child: Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 10),
                                child: Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: InkWell(
                                    onTap: () {
                                      // Handle onTap event
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/cartoon.png',
                                              width:
                                                  150, // Adjust size as needed
                                              height: 150,
                                            ),
                                            SizedBox(
                                                width:
                                                    10), // Add some space between image and text
                                            Text(
                                              'Explore Popular \n Items Below',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 49, 102, 49),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                        // const Text(
                                        //   "Quick Search",
                                        //   style: TextStyle(
                                        //     fontSize: 20,
                                        //     fontWeight: FontWeight.normal,
                                        //     color: Color.fromARGB(
                                        //         255, 49, 102, 49),
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              FoodWidget(
                                                imagePath:
                                                    'assets/images/food_items/cake.jpg',
                                                label: 'Cake',
                                                onTap: () {
                                                  prediction = 'Cake';
                                                  // Get value from search bar
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewBlankPage(
                                                            prediction:
                                                                prediction), // Navigate to the new blank page
                                                  ));
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              FoodWidget(
                                                imagePath:
                                                    'assets/images/food_items/lasagna.jpg',
                                                label: 'Lasagna',
                                                onTap: () {
                                                  prediction = 'Lasagna';
                                                  // Get value from search bar
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewBlankPage(
                                                            prediction:
                                                                prediction), // Navigate to the new blank page
                                                  ));
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              FoodWidget(
                                                imagePath:
                                                    'assets/images/food_items/pie.jpg',
                                                label: 'Apple Pie',
                                                onTap: () {
                                                  prediction = 'Apple Pie';
                                                  // Get value from search bar
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewBlankPage(
                                                            prediction:
                                                                prediction), // Navigate to the new blank page
                                                  ));
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              FoodWidget(
                                                imagePath:
                                                    'assets/images/food_items/pizza.jpg',
                                                label: 'Pizza',
                                                onTap: () {
                                                  prediction = 'Pizza';
                                                  // Get value from search bar
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewBlankPage(
                                                            prediction:
                                                                prediction), // Navigate to the new blank page
                                                  ));
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              FoodWidget(
                                                imagePath:
                                                    'assets/images/food_items/samosa.jpg',
                                                label: 'Samosa',
                                                onTap: () {
                                                  prediction = 'Samosa';
                                                  // Get value from search bar
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewBlankPage(
                                                            prediction:
                                                                prediction), // Navigate to the new blank page
                                                  ));
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              FoodWidget(
                                                imagePath:
                                                    'assets/images/food_items/wings.jpg',
                                                label: 'Chicken Wings',
                                                onTap: () {
                                                  prediction = 'Chicken Wings';
                                                  // Get value from search bar
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewBlankPage(
                                                            prediction:
                                                                prediction), // Navigate to the new blank page
                                                  ));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ))),
                        SizedBox(height: 30),
                        // Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          onHomePressed: () {
            // Handle home button press
          },
          onSearchPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(),
              ),
            );
          },
          onProfilePressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  displayName: user?.displayName ?? 'Guest',
                  email: user?.email ?? '',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
