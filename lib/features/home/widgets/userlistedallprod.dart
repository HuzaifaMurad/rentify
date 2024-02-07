import 'package:flutter/material.dart';

import '../../../models/product.dart';

class UserListedAllProduct extends StatelessWidget {
  const UserListedAllProduct({
    required this.product,
    super.key,
  });
  final Product product;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(
        //   RentalsDetailScreen.routeName,
        //   arguments: items[index],
        // );
      },
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          // Background color of the grid item
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(product.price.toString()),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  product.title.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text('${product.address},${product.location}'),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(product.postedDate.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
