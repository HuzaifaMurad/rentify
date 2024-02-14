import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/features/add_product/controller/product_controller.dart';
import 'package:rentify/features/home/screen/user_details_scrreen.dart';
import 'package:rentify/models/product.dart';

import '../../../models/report.dart';
import '../../add_product/widgets/addprod_textfield.dart';
import '../../auth/controller/auth_controller.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  static const routeName = '/product-detail-screen';
  const ProductDetailScreen({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    addView();
    super.initState();
  }

  void addView() {
    var user = ref.read(userProvider);

    Future.delayed(
      const Duration(seconds: 2),
      () {
        ref.read(addProductControllerProvider.notifier).updateView(
            id: widget.product.id!, userid: user!.id, context: context);
      },
    );
  }

  void addReport(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text(
                'Give Reason For Report',
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
                    title: 'Reason of report',
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
                    if (controller.text.isEmpty) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: const Text('Give reason'),
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
                    if (widget.product.report != null) {
                      if (isUserReported(widget.product.report!, user!.id)) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: const Text('already report submitted'),
                              margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.6,
                                left: 30,
                                right: 30,
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        return;
                      }
                    }

                    Report report =
                        Report(userId: user!.id, reason: controller.text);

                    ref
                        .read(addProductControllerProvider.notifier)
                        .reportProduct(
                            id: widget.product.id!,
                            report: report,
                            context: context);
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
                      'SUBMIT',
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

  static bool isUserReported(List<Report> reports, String userId) {
    for (var report in reports) {
      if (report.userId == userId) {
        return true;
      }
    }
    return false;
  }

  final List<String> imageUrls = [
    'https://a.storyblok.com/f/181238/820x547/d3eff61502/weekendje_weg_820x847.jpg',
    'https://cf.bstatic.com/xdata/images/hotel/max1024x768/195731211.jpg?k=42b4c492410d148eb82f701fb39f461241151776ef79b5ba2b00a0833c3f4118&o=&hp=1',
    'https://a.storyblok.com/f/181238/900x600/18b8c8334d/41141.png',
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        height: height * 0.5,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          log(index.toString());
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: widget.product.images.map((url) {
                        return Builder(
                          builder: (BuildContext context) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.product.images.map((url) {
                          int rindex = imageUrls.indexOf(url);

                          return Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == rindex
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 0,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                log('going back');
                              },
                              child: SizedBox(
                                height: 35,
                                width: 30,
                                child: Image.asset(
                                  'assets/images/Backspace.png',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    CupertinoIcons.download_circle,
                                    color: Color(0xff004D5E),
                                    size: 30,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Phone No:'),
                                          content: Text(
                                            widget.product.ownerContact!.isEmpty
                                                ? 'no contact info'
                                                : widget.product.ownerContact
                                                    .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Color(0xff004D5E),
                                    size: 30,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      UserDetasilsScreen.routeName,
                                      arguments: widget.product.ownerId,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.person,
                                    color: Color(0xff004D5E),
                                    size: 30,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: height * 0.47,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: height * 0.46,
                    decoration: const BoxDecoration(
                      color: Color(0xffF5F5F5),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(35),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Text(
                            widget.product.title!,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            widget.product.category == 'House'
                                ? '4 guest 2 bedroon 2 baths'
                                : 'posted by ${widget.product.ownerName}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Card(
                              elevation: 5,
                              surfaceTintColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.product.category == 'House'
                                ? 'What this place offer'
                                : 'Infomation you may know',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Card(
                                  elevation: 5,
                                  surfaceTintColor: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        widget.product.isAvailable!
                                            ? Icons.event_available
                                            : Icons.dangerous,
                                        size: 30,
                                        color: widget.product.isAvailable!
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      Text(
                                        widget.product.isAvailable!
                                            ? 'Available'
                                            : 'UnAvailable',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  addReport(context);
                                },
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    elevation: 5,
                                    surfaceTintColor: const Color(0xffFFFFFF),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.report),
                                        Text(
                                          'Report',
                                          style: Constants.titleRentify,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Card(
                                    elevation: 5,
                                    surfaceTintColor: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Interested ',
                                          style: Constants.titleRentify,
                                        ),
                                        Text(
                                          widget.product.view!.length
                                              .toString(),
                                          style: Constants.titleRentify,
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            widget.product.description!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          color: const Color(0xffF5F5F5),
                          alignment: Alignment.center,
                          child: Text(
                            'Rs ${widget.product.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(20)),
                            color: Color(0xff0BBDE9),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
