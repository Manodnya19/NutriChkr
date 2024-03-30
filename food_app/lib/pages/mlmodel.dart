// mlmodel.dart

import 'dart:io';
import 'package:tflite_v2/tflite_v2.dart';

class MLModel {
  var _recognitions;
  var v = "";

  // Load the machine learning model
  // Future<void> loadmodel() async {
  //   await Tflite.loadModel(
  //     model: "assets/images/model1.tflite",
  //     labels: "assets/images/classes.txt",
  //   );
  // }

  // Run inference on the provided image file
  Future<void> detectimage(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
        print('inside detect image!!!!!!!!!!!!!!!!!!!!!!!!!');
    // Run model on the image
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 3,
      threshold: 0.50,
      imageMean: 0,
      imageStd: 255,
    );

    // Update the internal state variables
    _recognitions = recognitions;
    v = recognitions.toString();

    // Handle the results or update UI as needed
    // For example, you might want to use these results to update the UI in ImageConfirmationPage

    print("//////////////////////////////////////////////////");
    print(_recognitions);
    print("//////////////////////////////////////////////////");

    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  // Add any additional methods or variables as needed
}
