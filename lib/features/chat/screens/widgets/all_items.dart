import 'package:flutter/material.dart';

class AllItems extends StatelessWidget {
  const AllItems({
    super.key,
    required this.formattedDate,
  });

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
            'https://media.timeout.com/images/105805277/750/422/image.jpg',
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Micheal'),
            const Text(
              'I like your item.Can you give me discount?',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Container(),
          ],
        ),
        const Spacer(),
        Flexible(
          child: Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
