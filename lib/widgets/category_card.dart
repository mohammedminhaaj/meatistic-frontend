import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meatistic/settings.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.name, required this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = Uri.https(baseUrl, image).toString();

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 20.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Material(
            elevation: 5,
            borderRadius: const BorderRadius.all(Radius.circular(60)),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(imageUrl),
              radius: 50,
            ),
          ),
          Positioned(
            bottom: -15,
            child: Material(
                elevation: 5,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ))),
          ),
        ],
      ),
    );
  }
}
