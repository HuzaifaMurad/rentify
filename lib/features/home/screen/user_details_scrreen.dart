import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/core/utility.dart';
import 'package:rentify/features/add_product/widgets/addprod_textfield.dart';
import 'package:rentify/features/user_profile/controller/user_profile_controller.dart';
import 'package:rentify/models/review.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../../../models/product.dart';
import '../../../models/user_models.dart';
import '../../add_product/controller/product_controller.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/userlistedallprod.dart';

class UserDetasilsScreen extends ConsumerStatefulWidget {
  const UserDetasilsScreen({super.key, required this.id});
  static const routeName = '/use-details-screen';
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserDetasilsScreenState();
}

class _UserDetasilsScreenState extends ConsumerState<UserDetasilsScreen> {
  bool isProduct = false;
  bool isReview = true;
  bool isLoading = true;
  final TextEditingController controller = TextEditingController();
  double? rating;
  double sum = 0;
  int length = 0;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  UserModel? userModel;

  void getData() async {
    userModel = await ref
        .read(authControllerProvider.notifier)
        .getSpecificUserData(widget.id);
    if (userModel!.reviews != null) {
      sum = calculateAverageRating(userModel!.reviews!);
    }
    log(sum.toString());

    isLoading = false;

    setState(() {});
  }

  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) {
      return 0.0; // Default value for no ratings
    }
    length = reviews.length;
    double sum = reviews
        .map((review) => review.rating)
        .reduce((value, element) => value + element);
    return sum / reviews.length;
  }

  void addReview(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text(
                'What is your rating?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: RatingBar.builder(
                    initialRating: 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rat) {
                      rating = rat;
                    },
                  ),
                ),
              ),
              const Text(
                'Please Share your opinion about the product',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AddProdTextField(
                    title: 'Your Review',
                    maxlines: 5,
                    color: Colors.white,
                    controller: controller,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    if (rating == null) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: const Text('Give Rating'),
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.6,
                              left: 30,
                              right: 30,
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      return;
                    }
                    if (controller.text.isEmpty) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: const Text('add rating'),
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.6,
                              left: 30,
                              right: 30,
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      return;
                    }
                    var user = ref.read(userProvider);

                    Review review = Review(
                      comments: controller.text.trim(),
                      rating: rating!,
                      reviewrName: user!.name,
                      reviwerProfileUrl: user.profilePic,
                      reviewerId: user.id,
                    );

                    ref
                        .read(userProfileControllerProvider.notifier)
                        .addUserReview(widget.id, review);
                    Navigator.of(context).pop();
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
                      'Add A review',
                      style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var product = ref.read(renalPostsProvider);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: Constants.appBarGradient,
          ),
        ),
        title: Text(
          'User Profile',
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            surfaceTintColor: Colors.white,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Report User',
                  child: Text('Option 1'),
                ),
                const PopupMenuItem<String>(
                  value: 'Report Product',
                  child: Text('Option 2'),
                ),
                // Add more items as needed
              ];
            },
            onSelected: (String value) {
              // Handle item selection here
              print('Selected: $value');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.amber,
                      backgroundImage: NetworkImage(
                        userModel!.profilePic,
                      ),
                    ),
                  ),
                  Text(
                    userModel!.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 27,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SmoothStarRating(
                        rating: sum,
                        size: 20,
                        allowHalfRating: true,
                        color: Colors.amber,
                        borderColor: Colors.amber,
                      ),
                    ),
                  ),
                  const Text(
                    'Over All Rating',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "$sum Rating Base on $length Reviews",
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isReview = false;
                                isProduct = true;
                              });
                            },
                            child: const Text('PRODUCT'),
                          ),
                          if (isProduct)
                            Container(
                              width: 50,
                              height: 3,
                              color: Colors.teal,
                            ),
                        ],
                      ),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isReview = true;
                                isProduct = false;
                              });
                            },
                            child: const Text('REVIEW'),
                          ),
                          if (isReview)
                            Container(
                              width: 50,
                              height: 3,
                              color: Colors.teal,
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (isProduct)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: product.when(
                        data: (products) {
                          // Filter out items where ownerId doesn't match widget.id
                          List<Product> filteredProducts = products
                              .where((prod) => prod.ownerId == widget.id)
                              .toList();

                          return GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (BuildContext context, int index) {
                              var prod = filteredProducts[index];
                              return UserListedAllProduct(
                                product: prod,
                              );
                            },
                          );
                        },
                        loading: () {
                          // Handle loading state
                          return CircularProgressIndicator();
                        },
                        error: (_, __) {
                          // Handle error state
                          return Text('Error fetching products');
                        },
                      ),
                    ),
                  if (isReview)
                    Container(
                      child: Column(
                        children: [
                          userModel!.reviews == null
                              ? const Center(
                                  child: Text('No Reviews yet'),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: userModel!.reviews!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var review = userModel!.reviews![index];

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundImage: NetworkImage(
                                                  review.reviwerProfileUrl,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '  ${review.reviewrName}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: SmoothStarRating(
                                                      rating: review.rating,
                                                      size: 20,
                                                      allowHalfRating: true,
                                                      color: Colors.amber,
                                                      borderColor: Colors.amber,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(review.comments),
                                          const Divider(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [

                          //     Text(
                          //       '3.0',
                          //       style: TextStyle(
                          //         fontSize: 25,
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: 80,
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(18.0),
                          //         child: RatingBar.builder(
                          //           initialRating: 3,
                          //           minRating: 1,
                          //           direction: Axis.horizontal,
                          //           allowHalfRating: true,
                          //           itemCount: 5,
                          //           itemPadding: const EdgeInsets.symmetric(
                          //               horizontal: 4.0),
                          //           itemBuilder: (context, _) => const Icon(
                          //             Icons.star,
                          //             color: Colors.amber,
                          //           ),
                          //           onRatingUpdate: (rating) {
                          //             print(rating);
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                addReview(context);
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: Constants.buttonGredient,
                                ),
                                child: Text(
                                  'Add A review',
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
