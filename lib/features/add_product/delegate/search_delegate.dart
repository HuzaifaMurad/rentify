import 'package:flutter/material.dart';
import 'package:rentify/core/utility.dart';
import 'package:rentify/models/cities.dart';

class CoinSearchDelegate extends SearchDelegate<Cities> {
  final List<Cities> coins;

  CoinSearchDelegate(this.coins);

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
        close(context, coins[0]);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // This method is called when the user selects a search result.
    // You can handle the selection here, e.g., navigate to a new page.
    // For this example, let's just return a text widget to show the selected item.
    return Center(
      child: Text('Selected: ${query.trim()}'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // This method is called whenever the user enters a new query in the search bar.
    // It provides the search suggestions based on the query.
    final List<Cities> suggestionList = query.isEmpty
        ? []
        : coins
            .where(
                (city) => city.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final city = suggestionList[index];
        return GestureDetector(
          onTap: () {
            close(context, city);
          },
          child: Column(
            children: [
              Text(
                city.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
