import 'package:aqua_exchange/app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:aqua_exchange/app/app_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key, required this.appNotifier});

  final ChangeNotifierProvider<AppProvider> appNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppProvider appProvider = ref.watch<AppProvider>(appNotifier);
    // print(appProvider.cart);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart (${appProvider.cart.isNotEmpty ? appProvider.cart.map((e) => e.count).reduce((value, element) => value + element) : 0})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomSheet: appProvider.cart.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price'),
                      Text(appProvider.totalPrice().toStringAsFixed(2)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GST(18%)'),
                      Text(appProvider.getGST().toStringAsFixed(2)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount'),
                      Text(appProvider.totalAmount()),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )
          : null,
      body: appProvider.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Cart is empty',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BackButton(),
                        SizedBox(width: 10),
                        Text(
                          'Add items',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.add_shopping_cart),
                        SizedBox(width: 7),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ...appProvider.cart
                      .map(
                        (e) => ProductListTile(
                          product: e,
                          appNotifier: appNotifier,
                          isCart: true,
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}
