import 'package:flutter/material.dart';
import 'package:rentify/core/utility.dart';
import 'package:rentify/features/home/widgets/home_item.dart';
import 'package:rentify/models/cities.dart';

import '../../../models/product.dart';
import '../screen/product_detail_screen.dart';

class HomeSearchDelegate extends SearchDelegate<Product> {
  final List<Product> data;

  HomeSearchDelegate(this.data);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, data[0]);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // This method is called when the user selects a search result.
    // You can handle the selection here, e.g., navigate to a new page.
    // For this example, let's just return a text widget to show the selected item.
    var height = MediaQuery.of(context).size.height;
    // This method is called whenever the user enters a new query in the search bar.
    // It provides the search suggestions based on the query.
    final List<Product> suggestionList = query.isEmpty
        ? []
        : data
            .where((city) =>
                city.location!.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final city = suggestionList[index];
        return GestureDetector(
          onTap: () {
            close(context, city);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: HomeItem(
              address: city.address!,
              category: city.category!,
              imageUrls: city.images,
              location: city.location!,
              title: city.title!,
              id: city.id!,
              price: city.price.toString(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // This method is called whenever the user enters a new query in the search bar.
    // It provides the search suggestions based on the query.
    final List<Product> suggestionList = query.isEmpty
        ? []
        : data
            .where((city) =>
                city.location!.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final city = suggestionList[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: city,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: HomeItem(
              address: city.address!,
              category: city.category!,
              imageUrls: city.images,
              location: city.location!,
              title: city.title!,
              id: city.id!,
              price: city.price.toString(),
            ),
          ),
        );
      },
    );
  }
}
