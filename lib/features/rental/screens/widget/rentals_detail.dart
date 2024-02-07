import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/features/add_product/screen/Edit_product.dart';
import 'package:rentify/features/home/screen/user_details_scrreen.dart';
import 'package:rentify/models/product.dart';

import '../../../../core/constants/constants.dart';
import '../../../home/screen/product_detail_screen.dart';

class RentalsDetailScreen extends ConsumerStatefulWidget {
  static const routeName = '/rentals-detail-screen';
  const RentalsDetailScreen({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RentalsDetailScreenState();
}

class _RentalsDetailScreenState extends ConsumerState<RentalsDetailScreen> {
  // final List<String> imageUrls = [
  //   'https://a.storyblok.com/f/181238/820x547/d3eff61502/weekendje_weg_820x847.jpg',
  //   'https://cf.bstatic.com/xdata/images/hotel/max1024x768/195731211.jpg?k=42b4c492410d148eb82f701fb39f461241151776ef79b5ba2b00a0833c3f4118&o=&hp=1',
  //   'https://a.storyblok.com/f/181238/900x600/18b8c8334d/41141.png',
  // ];
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
                          int rindex = widget.product.images.indexOf(url);

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
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Card(
                                  elevation: 5,
                                  surfaceTintColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Card(
                                  elevation: 5,
                                  surfaceTintColor: Color(0xffFFFFFF),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Card(
                                  elevation: 5,
                                  surfaceTintColor: Colors.white,
                                ),
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
                            widget.product.description.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: widget.product,
              );
            },
            child: Container(
              height: 70,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: Constants.buttonGredient,
              ),
              child: Text(
                'Edit Product',
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
