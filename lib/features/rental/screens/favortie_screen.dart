import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 10.0, // Spacing between columns
        mainAxisSpacing: 10.0, // Spacing between rows
        childAspectRatio: 0.8,
      ),
      itemCount: 20, // Total number of items in the grid
      itemBuilder: (BuildContext context, int index) {
        // Create a grid item for each index
        return Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            // Background color of the grid item
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        'https://hips.hearstapps.com/hmg-prod/images/2023-bmw-z4-m40i-130-64a6f8c96d505.jpg?crop=0.707xw:0.530xh;0.142xw,0.278xh&resize=1200:*',
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text('Rs 5000/day '),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        'Buggati MC-200 DenX Ver ',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text('Satellite Town,Rawalpindi '),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text('11 days ago '),
                    ),
                  ],
                ),
                Positioned(
                  right: 2,
                  top: 5,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
