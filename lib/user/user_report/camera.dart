import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  final _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String lat = "";
  String lng = "";
  String result = "";
  final customColor = Color.fromARGB(255, 245, 245, 228);
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 21, 24, 29),
      // Set background color
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white, // Change this color to the desired color
        ),
        backgroundColor: Color.fromARGB(255, 21, 24, 29),
        title: Text(
          'Upload Image',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: SingleChildScrollView(
        // Make the page scrollable
        child: Container(
          padding: EdgeInsets.all(16), // Add padding for better spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: _image == null
                    ? Text(
                        'No image selected.',
                        style: TextStyle(color: Colors.white),
                      )
                    : Image.file(_image!),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  setState(() {
                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                    }
                  });
                },
                child: Text('Select Image'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_auth.currentUser == null) {
                    Navigator.pushNamed(context, '/login');
                    return;
                  }

                  if (_image != null) {
                    Position position = await _getLocation();
                    String lat = position.latitude.toString();
                    String lng = position.longitude.toString();

                    firebase_storage.Reference ref = firebase_storage
                        .FirebaseStorage.instance
                        .ref()
                        .child('Report/${DateTime.now()}.jpg');

                    // Set latitude and longitude as metadata
                    firebase_storage.SettableMetadata metadata =
                        firebase_storage.SettableMetadata(
                      customMetadata: {
                        'latitude': lat,
                        'longitude': lng,
                      },
                    );

                    await ref.putFile(_image!).then((snapshot) async {
                      // Set metadata for the uploaded image
                      await snapshot.ref.updateMetadata(metadata);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Image uploaded successfully'),
                        ),
                      );
                    });

                    logger.d('File uploaded to Firebase Storage');
                  }
                },
                child: const Text('Upload Image'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getLocationButton(),
                  SizedBox(width: 20), // Add some spacing between buttons
                  _getMapButton(),
                ],
              ),
              const SizedBox(height: 20),
              displayLocation(),
              Text(
                result,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Permission denied';
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void saveToDatabase(String imageUrl, String lat, String lng) {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child("images");

    databaseReference.push().set({
      'imageUrl': imageUrl,
      'lat': lat,
      'lng': lng,
    }).then((_) {
      logger.d('Location and image URL saved to database');
    }).catchError((error) {
      logger.e('Failed to save location and image URL: $error');
    });
  }

  Widget _getMapButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
        width: 150, // Adjust the width as needed
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                customColor), // Use the custom creme color
            foregroundColor: MaterialStateProperty.all<Color>(
                Colors.black), // Black font color
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Custom border radius
              ),
            ),
          ),
          onPressed: () {
            goToMap();
          },
          child: const Text(
            "View location",
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _getLocationButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
        width: 150, // Adjust the width as needed
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                customColor), // Use the custom creme color
            foregroundColor: MaterialStateProperty.all<Color>(
                Colors.black), // Black font color
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Custom border radius
              ),
            ),
          ),
          onPressed: () {
            getUserLocation();
          },
          child: const Text(
            "Get Location",
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }

  Future<bool> checkPermission() async {
    bool isEnable = false;
    LocationPermission permission;

    isEnable = await Geolocator.isLocationServiceEnabled();
    if (!isEnable) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void getUserLocation() async {
    var isEnable = await checkPermission();
    if (isEnable) {
      Position location = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        lat = location.latitude.toString();
        lng = location.longitude.toString();
        result = "";
      });
    } else {
      setState(() {
        result = "Permission Denied!";
        lat = "";
        lng = "";
      });
    }
  }

  Widget displayLocation() {
    return Column(
      children: [
        Text(
          result,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          lat,
          style: const TextStyle(
              fontSize: 30, color: Color.fromARGB(255, 255, 255, 255)),
        ),
        Text(
          lng,
          style: const TextStyle(
              fontSize: 30, color: Color.fromARGB(255, 255, 255, 255)),
        )
      ],
    );
  }

  void goToMap() {
    try {
      if (lat.isNotEmpty && lng.isNotEmpty) {
        var url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
        logger.d("Opening Google Maps with URL: $url");
        launchUrl(Uri.parse(url));
      } else {
        logger.w("Location not available");
      }
    } catch (e) {
      logger.e("Error launching map: $e");
    }
  }
}
