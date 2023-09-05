import 'package:flutter/material.dart';
import 'package:meatistic/data/menu.dart';
import 'package:meatistic/screens/filter_product.dart';

class SortMenu extends StatelessWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 35,
        child: ListView.separated(
            shrinkWrap: true,
            itemCount: sortMenuList.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
              );
            },
            itemBuilder: (_, index) {
              return OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FilterProduct(
                        filterQuery: sortMenuList[index].filterName,
                      ),
                    ));
                  },
                  child: Text(sortMenuList[index].name));
            }),
      ),
    );
  }
}
