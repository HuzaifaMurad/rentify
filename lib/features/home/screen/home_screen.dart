// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/features/add_product/controller/product_controller.dart';
import 'package:rentify/features/home/screen/product_detail_screen.dart';
import 'package:rentify/features/home/screen/smart_search.dart';
import 'package:rentify/features/home/widgets/home_item.dart';
import 'package:rentify/features/home/widgets/search_delegate_home.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/product.dart';
import '../widgets/searchbar.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';
  List<Product> items = [];
  List<String> labeltext = [];
  bool isSmartSerch = false;

  Future<void> uploadImageSmartSearch() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      isSmartSerch = true;
    });
    var uri =
        Uri.parse('https://objects-detection.p.rapidapi.com/objects-detection');
    var request = http.MultipartRequest('POST', uri);

    // Adding image from file
    var file = File(pickedFile.path);
    var image = await http.MultipartFile.fromPath('image', file.path);
    request.files.add(image);

    // Adding URL
    request.fields['url'] =
        'https://openmediadata.s3.eu-west-3.amazonaws.com/birds.jpeg';

    // Adding headers
    request.headers.addAll({
      'X-RapidAPI-Key': '80e6adbe67mshd6f55849d46e445p136aedjsn3444d46e7577',
      'X-RapidAPI-Host': 'objects-detection.p.rapidapi.com',
    });

    try {
      var response = await http.Response.fromStream(await request.send());

      processApiResponse(response.body);
      setState(() {
        isSmartSerch = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void processApiResponse(String responseBody) {
    // Parse the JSON response
    Map<String, dynamic> jsonResponse = json.decode(responseBody);

    // Extract keywords from the response
    List<dynamic> keywords = jsonResponse['body']['keywords'];

    // Convert dynamic list to List<String>
    labeltext = List<String>.from(keywords);
  }

  Future<void> labelImage() async {
    // Pick an image from gallery
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    final inputImage = InputImage.fromFilePath(pickedFile!.path);

    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.8);
    final imageLabeler = ImageLabeler(options: options);
    labeltext.clear();
    try {
      // Perform image labeling
      final List<ImageLabel> labels =
          await imageLabeler.processImage(inputImage);
      for (ImageLabel label in labels) {
        final String text = label.label;
        final double confidence = label.confidence;
        labeltext.add(text);
        log('Label: $text, Confidence: $confidence');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      imageLabeler.close(); // Don't forget to close the image labeler when done
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return ref.watch(renalPostsProvider).when(
          data: (data) {
            return Scaffold(
              backgroundColor: Constants.scaffoldbackgroundColor2,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await showSearch<Product>(
                                context: context,
                                delegate: HomeSearchDelegate(data),
                              );
                            },
                            child: const SearchBarHome(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Browse Categories',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await uploadImageSmartSearch();

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SmartSearchResult(
                                          product: data, label: labeltext),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Smart Search',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.09,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: Constants.homeCategories.length,
                              itemBuilder: (BuildContext context, int index) {
                                var cate = Constants.homeCategories[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = cate.title;
                                      log('${selectedCategory} is selected');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          cate.icon,
                                          height: 40,
                                          width: 40,
                                        ),
                                        Text(
                                          cate.title,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: selectedCategory ==
                                                        Constants
                                                            .homeCategories[
                                                                index]
                                                            .title
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (selectedCategory == 'All') {
                                  if (data[index].status == 'active') {
                                    return GestureDetector(
                                      onTap: () =>
                                          Navigator.of(context).pushNamed(
                                        ProductDetailScreen.routeName,
                                        arguments: data[index],
                                      ),
                                      child: HomeItem(
                                        address: data[index].address!,
                                        category: data[index].category!,
                                        imageUrls: data[index].images,
                                        location: data[index].location!,
                                        title: data[index].title!,
                                        id: data[index].id!,
                                        price: data[index].price.toString(),
                                      ),
                                    );
                                  }
                                } else if (selectedCategory ==
                                    data[index].category) {
                                  var selected = data[index];
                                  if (selected.status == 'active') {
                                    return GestureDetector(
                                      onTap: () =>
                                          Navigator.of(context).pushNamed(
                                        ProductDetailScreen.routeName,
                                        arguments: selected,
                                      ),
                                      child: HomeItem(
                                        address: selected.address!,
                                        category: selected.category!,
                                        imageUrls: selected.images,
                                        location: selected.location!,
                                        title: selected.title!,
                                        id: selected.id!,
                                        price: selected.price.toString(),
                                      ),
                                    );
                                  }
                                }
                                return Container();
                              },
                            ),
                          )
                        ],
                      ),
                      if (isSmartSerch)
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            print(error);
            return ErrorText(
              errorText: error.toString(),
            );
          },
          loading: () => const Loader(),
        );
  }
}
