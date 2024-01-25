import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/features/add_product/controller/product_controller.dart';
import 'package:rentify/features/home/screen/product_detail_screen.dart';

import 'package:rentify/features/home/widgets/home_item.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../widgets/searchbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';
  List<Product> items = [];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return ref.watch(renalPostsProvider).when(
          data: (data) {
            // for (var d in data) {
            //   if (selectedCategory == 'All') {
            //     items.add(d);
            //   } else if (selectedCategory == d.category) {
            //     items = [];
            //     items.add(d);
            //   }
            // }
            return Scaffold(
              backgroundColor: Constants.scaffoldbackgroundColor2,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SearchBarHome(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Browse Categories',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See All',
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                                        .homeCategories[index]
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
                              return GestureDetector(
                                  onTap: () => Navigator.of(context).pushNamed(
                                        ProductDetailScreen.routeName,
                                        arguments: data[index],
                                      ),
                                  child: HomeItem(
                                    address: data[index].address!,
                                    category: data[index].category!,
                                    imageUrls: data[index].images,
                                    location: data[index].location!,
                                    title: data[index].title!,
                                    price: data[index].price.toString(),
                                  ));
                            } else if (selectedCategory ==
                                data[index].category) {
                              var selected = data[index];
                              return GestureDetector(
                                  onTap: () => Navigator.of(context).pushNamed(
                                        ProductDetailScreen.routeName,
                                        arguments: selected,
                                      ),
                                  child: HomeItem(
                                    address: selected.address!,
                                    category: selected.category!,
                                    imageUrls: selected.images,
                                    location: selected.location!,
                                    title: selected.title!,
                                    price: selected.price.toString(),
                                  ));
                            }
                            return Container();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return ErrorText(
              errorText: error.toString(),
            );
          },
          loading: () => const Loader(),
        );
  }
}
