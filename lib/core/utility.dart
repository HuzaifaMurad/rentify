import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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

// class StyledSnackbar {
//   static OverlayEntry? _currentEntry;

//   static void show(BuildContext context, String message) {
//     _removeCurrentSnackbar();

//     final entry = OverlayEntry(
//       builder: (context) {
//         return Positioned(
//           top: MediaQuery.of(context).size.height - 120,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.blue.withOpacity(0.7),
//                     Colors.purple.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(15),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                         child: Container(
//                           height: 50,
//                           width: MediaQuery.of(context).size.width * 0.9,
//                           alignment: Alignment.center,
//                           color: Colors.transparent,
//                           child: Text(
//                             message,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               decoration: TextDecoration.none,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );

//     _currentEntry = entry;
//     Overlay.of(context).insert(entry);
//     Future.delayed(const Duration(seconds: 2), () {
//       _removeCurrentSnackbar();
//     });
//   }

//   static void _removeCurrentSnackbar() {
//     if (_currentEntry != null) {
//       _currentEntry!.remove();
//       _currentEntry = null;
//     }
//   }
// }

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform
      .pickFiles(type: FileType.image, allowMultiple: true);
  return image;
}

//the singleton approch is better in that case if i want to add more fetures to StyledSnackbar
/*
class StyledSnackbar {
   static StyledSnackbar? _instance;

  // Private constructor to prevent direct instantiation
  StyledSnackbar._();

  // Get or create the singleton instance
  static StyledSnackbar get instance {
    _instance ??= StyledSnackbar._();
    return _instance!;
  }
  static OverlayEntry? _currentEntry;

   void show(BuildContext context, String message) {
    _removeCurrentSnackbar();

    final entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height - 120,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.7),
                    Colors.purple.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Text(
                            message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    _currentEntry = entry;
    Overlay.of(context).insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      _removeCurrentSnackbar();
    });
  }

  void _removeCurrentSnackbar() {
    if (_currentEntry != null) {
      _currentEntry!.remove();
      _currentEntry = null;
    }
  }
}
 */