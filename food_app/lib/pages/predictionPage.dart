import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_app/widgets/background-image.dart';

class PredictionPage extends StatelessWidget {
  final String prediction;

  PredictionPage({required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
       const BackgroundImage(),
        Scaffold(
      appBar: AppBar(
        title: Text('Prediction'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white.withOpacity(0.8), // Semi-transparent card
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Prediction Result:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      prediction,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: FaIcon(FontAwesomeIcons.check),
                          label: Text('Confirm'),
                          onPressed: () {
                            // Handle user confirming the prediction
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton.icon(
                          icon: FaIcon(FontAwesomeIcons.times),
                          label: Text('Deny'),
                          onPressed: () {
                            // Handle user denying the prediction
                            Navigator.pop(context, false);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    )
      ],

    );    
  }
}
