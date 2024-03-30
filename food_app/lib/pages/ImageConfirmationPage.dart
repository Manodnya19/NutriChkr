// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:food_app/widgets/background-image.dart';
// import 'package:tflite_v2/tflite_v2.dart';
// import 'mlmodel.dart';
// import 'NewBlankPage.dart'; // Import the new blank page

// class ImageConfirmationPage extends StatelessWidget {
//   final File capturedImage;
//   final MLModel mlModel = MLModel(); // Create an instance of MLModel

//   ImageConfirmationPage({required this.capturedImage});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // const BackgroundImage(),
//         Scaffold(
//           backgroundColor: const Color.fromARGB(255, 243, 243, 243),
//           appBar: AppBar(
//             title: Text('Image Confirmation'),
//             backgroundColor: Color.fromARGB(255, 73, 145, 76),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 400,
//                   height: 400,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white, width: 2.0),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Image.file(
//                     capturedImage,
//                     fit: BoxFit
//                         .cover, // This will fill the entire container with the image
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Do you want to proceed with this image?',
//                   style: TextStyle(fontSize: 18, color: Colors.black),
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.green,
//                         onPrimary: Colors.white,
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//                       ),
//                       onPressed: () {
//                         runModelOnImage(context, capturedImage);
//                       },
//                       child: Text('Yes'),
//                     ),
//                     SizedBox(width: 16),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.red,
//                         onPrimary: Colors.white,
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//                       ),
//                       onPressed: () {
//                         // Handle 'No' option
//                         Navigator.pop(context);
//                       },
//                       child: Text('No'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void runModelOnImage(BuildContext context, File image) async {
//     // Load the ML model if not already loaded
//     print('before model load function!!!!!!!!!!!!!!!!!!!!!!!!!');
//     await Tflite.loadModel(
//       model: "assets/images/model1.tflite",
//       labels: "assets/images/classes.txt",
//     );
//     print('model loaded!!!!!!!!!!!!!!!!!!!!!!!!!');

//     // Run the ML model on the captured image
//     await mlModel.detectimage(image);
//     String labelName = mlModel.v.split(',')[2];
//     String finalName = labelName.split(' ')[2];
//     if (finalName.contains('_')) {
//       finalName = finalName.replaceAll('_', ' ');
//     }

//     // Navigate to the new blank page directly with the prediction result
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (context) => NewBlankPage(prediction: finalName),
//     ));
//   }
// }
