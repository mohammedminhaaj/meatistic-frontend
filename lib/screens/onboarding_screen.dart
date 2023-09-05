import 'package:flutter/material.dart';
import 'package:meatistic/widgets/hero_content.dart';
import 'package:meatistic/models/hero_content_item.dart';
import 'package:meatistic/data/hero_content.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: heroContentList.length,
            itemBuilder: (ctx, index) {
              final HeroContentItem heroContentItem = heroContentList[index];
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.7), BlendMode.dstATop),
                    image: AssetImage(
                        "assets/images/${heroContentItem.backgroudImage}"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: HeroContent(
                  index,
                  heroContentItem.headerNormal,
                  heroContentItem.headerBold,
                  heroContentItem.description,
                ),
              );
            }));
  }
}
