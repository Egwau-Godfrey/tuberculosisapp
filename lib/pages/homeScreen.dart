import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;


class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<Homescreen> {

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  
  //###############################################################

  late Interpreter _interpreter;

  Future<void> _loadModel() async {
    final options = InterpreterOptions();
    _interpreter = await Interpreter.fromAsset('assets/third_model.tflite', options: options);
  }

  @override
  void initState() {
    super.initState();
    _loadModel();
  }


  //##############################################################

  void _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  void _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _scanImage(BuildContext context) async {
    if (_image == null) return;

    // Load and preprocess the image
    final imageData = await File(_image!.path).readAsBytes();
    img.Image? image = img.decodeImage(imageData);
    if (image == null) return;

    // Resize the image to match your model's input size (256x256)
    image = img.copyResize(image, width: 256, height: 256);

    // Convert the image to a Float32List
    var input = Float32List(1 * 256 * 256 * 3);
    var pixelIndex = 0;
    for (var y = 0; y < 256; y++) {
      for (var x = 0; x < 256; x++) {
        var pixel = image.getPixel(x, y);
        input[pixelIndex++] = pixel.r / 255.0;  // Red
        input[pixelIndex++] = pixel.g / 255.0;  // Green
        input[pixelIndex++] = pixel.b / 255.0;  // Blue
      }
    }

    // Reshape input tensor
    var inputShape = [1, 256, 256, 3];
    var outputShape = [1, 1]; // Changed to [1, 1] for binary classification
    var output = List.filled(1, 0.0).reshape(outputShape);

    // Run inference
    _interpreter.run(input.reshape(inputShape), output);

    // Process the output
    var result = output[0][0]; // Single value between 0 and 1

    // Interpret the result
    String diagnosis = result > 0.5 ? "Tuberculosis" : "Normal";
    double confidence = result > 0.5 ? result * 100 : (1 - result) * 100;

    // Display the result
    print("Diagnosis: $diagnosis");
    print("Confidence: ${confidence.toStringAsFixed(2)}%");

    saveHistory(diagnosis, confidence);

    bottomSheet(context: context, diagnosis: diagnosis, confidence: confidence);



    // TODO: Update UI with the result
  }

  FirebaseDatabase database = FirebaseDatabase.instance;
  int sequenceNumber = 0; // Replace with logic to get a unique sequence number (explained below)

  void saveHistory(String diagnosis, double confidence) async {
    sequenceNumber += 1;
    
    final SharedPreferences userUID = await SharedPreferences.getInstance();

    final String? uid = userUID.getString('UID');
    if (uid == null) {
      print('Error: UID is null');
      return;
    }

    final userPatientHistory = database.ref().child('users/$uid/saved_history');

    DateTime now = DateTime.now();
    
    String time = now.toIso8601String();

    
    String uniqueId = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${sequenceNumber}";

    // Prepare user data to be stored
    final savedHistory = {
      'diagnosis': diagnosis,
      'confidence': confidence,
      'time': time,
    };
    print(time);

    await userPatientHistory.child(uniqueId).set(savedHistory);

    
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _newElevatedBtn(btnText: "Take Image", onPressed: _takePicture, isBlue: false, context: context),
                    _newElevatedBtn(btnText: "Select Image", onPressed: _selectImage, isBlue: false, context: context),
                  ],
                ),
              ),
        
              Column(
                children: [
                  const SizedBox(height: 16),
        
                  const Divider(
                    height: 10,
                    color: Colors.black,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
        
                  if(_image != null) ... [
                    const SizedBox(height: 16.0), 
                    Image.file(File(_image!.path))
                  ],
                  if(_image == null) ... [
                    const SizedBox(height: 280),
                  ],
        
                  const SizedBox(height: 16),
        
                  const Divider(
                    height: 10,
                    color: Colors.black,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                ],
              ),
        
              const SizedBox(height: 16),

              _newElevatedBtn(
                btnText: "Scan Image", 
                onPressed: () async {
                  try {
                    await _scanImage(context);
                  } catch (e) {
                    print('Error scanning image: $e');
                    // Optionally show an error dialog or snackbar here
                  }
                }, 
                isBlue: true, 
                context: context
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }
}

Widget _newElevatedBtn({
  required String btnText,
  required VoidCallback onPressed,
  required bool isBlue, 
  required BuildContext context,
}) {

  double screenWidth = MediaQuery.of(context).size.width;

  double buttonWidth = screenWidth * 0.4; // This will make the button 40% of the screen width
  double buttonHeight = 50; 

  return ElevatedButton(
    onPressed: onPressed,

    style: ElevatedButton.styleFrom(

      minimumSize: ui.Size(buttonWidth, buttonHeight),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      // Correct implementation using backgroundColor
      backgroundColor: isBlue ? Colors.blue : null, // Use backgroundColor directly
      
    ),

    child: Text(
      btnText,
      style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
    ),
  );
}


Future<dynamic> bottomSheet({
  required BuildContext context,
  required String diagnosis,
  required double confidence,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Results",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Diagnosis:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        diagnosis,
                        style: TextStyle(
                          fontSize: 22,
                          color: diagnosis == "Tuberculosis" ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Confidence:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${confidence.toStringAsFixed(2)}%",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


