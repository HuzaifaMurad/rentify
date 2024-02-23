import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'dart:io';
// import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

import '../models/cities.dart';

List<Cities> cities = [];

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}

Future<List<Cities>> fetchCitiesFromJsonAsset(String assetPath) async {
  try {
    // Load the JSON file from the assets folder
    final String fileContent = await rootBundle.loadString(assetPath);

    // Parse JSON data
    final List<dynamic> jsonList = json.decode(fileContent);

    // Convert JSON data to a list of Cities objects
    final List<Cities> citiesList =
        jsonList.map((json) => Cities.fromMap(json)).toList();

    return citiesList;
  } catch (e) {
    // Handle any errors that might occur during the process
    print('Error fetching cities from JSON asset: $e');
    return [];
  }
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform
      .pickFiles(type: FileType.image, allowMultiple: true);
  return image;
}
