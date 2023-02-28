import 'package:flutter/material.dart';
import 'package:flutter_products/models/models.dart';
import 'package:flutter_products/screens/screens.dart';
import 'package:flutter_products/services/services.dart';
import 'package:flutter_products/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) {
      return const LoadingScreen();
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('List of products'),
            centerTitle: true,
          ),
          drawer: const SideMenu(),
          body: RefreshIndicator(
            onRefresh: () async {
              await productsService.reloadProducts();
            },
            child: ListView.builder(
              itemCount: productsService.products.length,
              itemBuilder: ((context, index) => GestureDetector(
                    onTap: () {
                      productsService.selectedProduct =
                          productsService.products[index].copy();
                      Navigator.pushNamed(context, 'product');
                    },
                    child: ProductCard(
                      product: productsService.products[index],
                    ),
                  )),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              productsService.selectedProduct =
                  Product(available: false, name: '', price: 0);
              Navigator.pushNamed(context, 'product');
            },
            child: const Icon(Icons.add),
          ),
        ),
      );
    }
  }
}
