import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rentify/features/home/widgets/home_item.dart';
import 'package:rentify/models/product.dart';

class SmartSearchResult extends StatefulWidget {
  const SmartSearchResult(
      {super.key, required this.product, required this.label});
  final List<Product> product;
  final List<String> label;

  @override
  State<SmartSearchResult> createState() => _SmartSearchResultState();
}

class _SmartSearchResultState extends State<SmartSearchResult> {
  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = widget.product.where((prod) {
      // Check if the product title contains any of the labels
      bool titleMatches = widget.label.any((lbl) => prod.title!.contains(lbl));
      // Check if the product category contains any of the labels
      bool categoryMatches =
          widget.label.any((lbl) => prod.category!.contains(lbl));
      // Return true if either the title or category matches any of the labels
      return titleMatches || categoryMatches;
    }).toList();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: filteredProducts.isEmpty
            ? const Center(
                child: Text('no product exit'),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: HomeItem(
                      address: filteredProducts[index].address!,
                      category: filteredProducts[index].category!,
                      imageUrls: filteredProducts[index].images,
                      location: filteredProducts[index].location!,
                      title: filteredProducts[index].title!,
                      id: filteredProducts[index].id!,
                      price: filteredProducts[index].price.toString(),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
