import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentify/models/product.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utility.dart';
import '../../../models/cities.dart';
import '../controller/product_controller.dart';
import '../delegate/search_delegate.dart';
import '../widgets/addprod_textfield.dart';
import '../widgets/choose_cat_field.dart';
import '../widgets/search_city.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  static const routeName = '/edit-product-screen';
  const EditProductScreen({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  // List<PlatformFile> files = [];
  int currentIndex = 0;
  String? selectedCategory;
  String? selectedCondition;
  String? availableStatus;
  bool? availableStatuses;
  String? selectedLocation;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initilize();
  }

  initilize() {
    titleController.text = widget.product.title.toString();
    priceController.text = widget.product.price.toString();
    descriptionController.text = widget.product.description.toString();
    locationController.text = widget.product.location.toString();

    selectedCategory = widget.product.category; // Store the selected category
    selectedCondition = 'Used';
    availableStatuses = widget.product.isAvailable;
    availableStatus = widget.product.isAvailable.toString();
    selectedLocation = widget.product.location;
  }
  // List<File> selectedImages = [];
  // FilePickerResult? images;

  // final picker = ImagePicker();

  // Future<void> getImages() async {
  //   // Check if the total number of selected images is less than 20
  //   if (selectedImages.length >= 5) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Maximum 20 pictures allowed'),
  //       ),
  //     );
  //     return;
  //   }

  // final pickedFiles = await picker.pickMultiImage(
  //   imageQuality: 100,
  //   maxHeight: 1000,
  //   maxWidth: 1000,
  // );

  // if (pickedFiles.isNotEmpty) {
  //   // Map XFiles to Files
  //   final List<File> files =
  //       pickedFiles.map((file) => File(file.path)).toList();

  //   // Check if adding the new images exceeds the limit
  //   if (selectedImages.length + files.length > 50) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Adding these images exceeds the limit of 20.'),
  //       ),
  //     );
  //     return;
  //   }

  //     setState(() {
  //       selectedImages.addAll(files);
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Nothing is selected'),
  //       ),
  //     );
  //   }
  // }

  void _showCategoryPicker(BuildContext context, option, bool category) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    category ? 'Select a Category' : 'Select a Condition',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: option.length,
                  itemBuilder: (BuildContext context, int index) {
                    var cat = option[index];

                    return ListTile(
                      title: Text(category ? cat.title : cat),
                      onTap: () {
                        setState(
                          () {
                            if (category) {
                              selectedCategory = cat.title;
                              print(selectedCategory);
                            } else {
                              selectedCondition = cat;
                              print(selectedCondition);
                            }
                          },
                        );

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStatus(BuildContext context, List<String> option) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    'Show Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: option.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(option[index]),
                      onTap: () {
                        setState(() {
                          if (option[index].toLowerCase() == 'true') {
                            setState(
                              () {
                                availableStatus = option[index];
                                availableStatuses = true;
                                log(availableStatuses.toString() + 'if');
                              },
                            );
                          } else {
                            setState(() {
                              availableStatus = option[index];
                              availableStatuses = false;
                              log(availableStatuses.toString() + 'else');
                            });
                          }
                        });

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // _pickFile() async {
  //   FilePickerResult? result =
  //       await FilePicker.platform.pickFiles(allowMultiple: true,);

  //   if (result != null) {
  //     files = result.files;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: Constants.appBarGradient,
          ),
        ),
        title: Text(
          'New Listing',
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // GestureDetector(
              //   onTap: () async {
              //     getImages();

              //     // images = await pickImage();
              //     // if (images != null) {}

              //     // setState(() {});
              //   },
              //   child: DottedBorder(
              //     borderType: BorderType.RRect,
              //     radius: const Radius.circular(15),
              //     dashPattern: const [10, 4],
              //     strokeCap: StrokeCap.round,
              //     color: Colors.black,
              //     child: Container(
              //       width: double.infinity,
              //       height: 150,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       child: selectedImages.isEmpty
              //           ? const Center(
              //               child: Icon(
              //                 Icons.camera_alt_outlined,
              //                 size: 40,
              //               ),
              //             )
              //           : CarouselSlider(
              //               options: CarouselOptions(
              //                 aspectRatio: 16 / 9,
              //                 viewportFraction: 1,
              //                 height: height * 0.3,
              //                 enlargeCenterPage: true,
              //                 onPageChanged: (index, reason) {
              //                   log(index.toString());
              //                   setState(() {
              //                     currentIndex = index;
              //                   });
              //                 },
              //               ),
              //               items: selectedImages.map((url) {
              //                 return Builder(
              //                   builder: (BuildContext context) {
              //                     return Container(
              //                       decoration: BoxDecoration(
              //                           borderRadius:
              //                               BorderRadius.circular(15)),
              //                       width: MediaQuery.of(context).size.width,
              //                       child: ClipRRect(
              //                         borderRadius: BorderRadius.circular(15),
              //                         child: Image.file(
              //                           File(url.path),
              //                           fit: BoxFit.cover,
              //                         ),
              //                       ),
              //                     );
              //                   },
              //                 );
              //               }).toList(),
              //             ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              AddProdTextField(
                title: 'Title',
                controller: titleController,
              ),
              const SizedBox(
                height: 15,
              ),
              AddProdTextField(
                title: 'Price',
                controller: priceController,
              ),
              const SizedBox(
                height: 15,
              ),
              AddProdTextField(
                title: 'Description',
                maxlines: 4,
                controller: descriptionController,
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  _showCategoryPicker(context, Constants.categories, true);
                },
                child: ChooseCategoryField(
                  selectedCategory: selectedCategory!,
                  title: 'Select a category',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  _showCategoryPicker(context, Constants.condition, false);
                },
                child: ChooseCategoryField(
                  selectedCategory: selectedCondition!,
                  title: 'Select a Condition',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  _showStatus(context, Constants.statuses);
                },
                child: ChooseCategoryField(
                  selectedCategory: availableStatus!,
                  title: 'status',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  final selectedCoin = await showSearch<Cities>(
                    context: context,
                    delegate: CoinSearchDelegate(cities),
                  );

                  if (selectedCoin != null) {
                    // Handle the selected coin here, e.g., show details or navigate to a new page.
                    // For this example, we'll just print the selected coin's name.

                    log('selected Citiy: ${selectedCoin.name}');
                    setState(() {
                      selectedLocation = selectedCoin.name;
                    });
                  }
                },
                child: CitiySearch(location: selectedLocation!),
              ),
              const SizedBox(
                height: 15,
              ),
              AddProdTextField(
                  title: 'Enter Address', controller: locationController),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  if (titleController.text.isEmpty) {
                    showSnackBar(context, 'please enter Title');
                    return;
                  } else if (priceController.text.isEmpty) {
                    showSnackBar(context, 'please enter Price');
                    return;
                  } else if (descriptionController.text.isEmpty) {
                    showSnackBar(context, 'please enter Description');
                    return;
                  } else if (locationController.text.isEmpty) {
                    showSnackBar(context, 'please enter location');
                    return;
                  }
                  var editedProduct = Product(
                    id: widget.product.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    price: double.parse(priceController.text),
                    images: widget.product.images,
                    category: selectedCategory,
                    isAvailable: availableStatuses,
                    postedDate: widget.product.postedDate,
                    location: selectedLocation,
                    address: locationController.text,
                    ownerId: widget.product.ownerId,
                    ownerName: widget.product.ownerName,
                    ownerContact: widget.product.ownerContact,
                  );

                  ref
                      .watch(addProductControllerProvider.notifier)
                      .editProfile(product: editedProduct, context: context);
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: Constants.buttonGredient,
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
