import 'package:flutter/material.dart';

class HelpAndFAQ extends StatelessWidget {
  const HelpAndFAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help and FAQ"),
      ),

      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "FAQ Section",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What is the purpose of this app?", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("The app uses a sophisticated deep learning model called a Convolutional Neural Network (CNN). This model is trained on thousands of chest X-rays to recognize patterns associated with TB. When you upload an image, the model analyzes it and provides an assessment of the likelihood of TB.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                  Text("Is this app a replacement for a doctor's diagnosis?", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("No. This app is a tool to aid healthcare professionals. The results provided by the app should always be interpreted by a qualified medical expert.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                  Text("How accurate is the app?", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("The accuracy of the app is based on the quality of the training data and the model's performance. While it strives for high accuracy, there is always a chance of false positives or false negatives.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Help Section",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("How to use the app", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Take a clear picture of the chest X-ray or upload an existing digital image.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                  Text("Ensure the image is in focus and properly aligned.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                  Text("Tap 'Analyze' and wait for the results.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                  Text("Review the assessment and consult with a healthcare professional for further evaluation.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                  Text("Troubleshooting", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("If the app crashes or encounters an error, try restarting it.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                  Text("If you have trouble uploading an image, ensure the file is in a compatible format (JPEG, PNG) and not too large.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                  Text("If the results seem inaccurate, try uploading a different image or consult with a healthcare professional.", textAlign: TextAlign.justify),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}