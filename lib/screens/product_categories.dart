import 'package:flutter/material.dart';

class ProductCategories extends StatefulWidget {
  const ProductCategories({super.key});

  @override
  State<ProductCategories> createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.primary
                      ])),
                ),
                centerTitle: true,
                title: const Text(
                  "Categories",
                )),
            expandedHeight: MediaQuery.of(context).size.height * .25,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.white),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
