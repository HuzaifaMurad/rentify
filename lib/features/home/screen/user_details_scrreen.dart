import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/features/add_product/widgets/addprod_textfield.dart';

class UserDetasilsScreen extends ConsumerStatefulWidget {
  const UserDetasilsScreen({super.key});
  static const routeName = '/use-details-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserDetasilsScreenState();
}

class _UserDetasilsScreenState extends ConsumerState<UserDetasilsScreen> {
  bool isProduct = false;
  bool isReview = true;
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                    onRatingUpdate: (rating) {
                      print(rating);
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
                  onTap: () {},
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.amber,
                backgroundImage: NetworkImage(
                  'https://media.timeout.com/images/105805277/750/422/image.jpg',
                ),
              ),
            ),
            const Text(
              'Huzaifa Murad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
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
            if (isReview)
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '3.0',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
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
                      ],
                    ),
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
