import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../../user_profile/controller/user_profile_controller.dart';

class HomeItem extends ConsumerStatefulWidget {
  const HomeItem(
      {super.key,
      required this.imageUrls,
      required this.title,
      required this.category,
      required this.location,
      required this.price,
      required this.id,
      required this.address});
  final List<String> imageUrls;
  final String title;
  final String category;
  final String location;
  final String address;
  final String price;
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeItemState();
}

class _HomeItemState extends ConsumerState<HomeItem> {
  final List<String> imageUrls = [
    'https://a.storyblok.com/f/181238/820x547/d3eff61502/weekendje_weg_820x847.jpg',
    'https://cf.bstatic.com/xdata/images/hotel/max1024x768/195731211.jpg?k=42b4c492410d148eb82f701fb39f461241151776ef79b5ba2b00a0833c3f4118&o=&hp=1',
    'https://a.storyblok.com/f/181238/900x600/18b8c8334d/41141.png',
  ];
  int _currentIndex = 0;

  void updateFavorite(String id, String uid) {
    ref
        .read(userProfileControllerProvider.notifier)
        .updateUserFavorite(id, uid);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var user = ref.watch(userProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  height: height * 0.3,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    log(index.toString());
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: widget.imageUrls.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imageUrls.map((url) {
                    int rindex = widget.imageUrls.indexOf(url);

                    return Container(
                      width: 10.0,
                      height: 10.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentIndex == rindex ? Colors.blue : Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  onPressed: () {
                    updateFavorite(widget.id, user.id);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: user!.favorite.contains(widget.id)
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Row(
                children: [
                  Icon(Icons.star),
                  Text(
                    'Rating 4.9',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          Text(
            widget.category,
            style: const TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            widget.location,
            style: const TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            widget.address,
            style: const TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(
            style: const TextStyle(fontSize: 15, color: Colors.black),
            children: [
              TextSpan(
                text: widget.price,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const TextSpan(text: ' Rs'),
            ],
          ))
        ],
      ),
    );
  }
}
