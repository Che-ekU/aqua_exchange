import 'package:aqua_exchange/app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:aqua_exchange/app/app_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({
    super.key,
    required this.product,
    required this.appNotifier,
  });

  final ChangeNotifierProvider<AppProvider> appNotifier;
  final ProductSchema product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String productDesc = (product.description ?? '-').toString();
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: product.thumbnail != null
                ? Image.network(
                    product.thumbnail!,
                    fit: BoxFit.contain,
                  )
                : null,
          ),
          const SizedBox(height: 5),
          Text(
            (product.title ?? '-').toString(),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            productDesc,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text('\$ ${(product.price ?? '-')}'),
          const SizedBox(height: 5),
          Consumer(
            builder: (context, WidgetRef ref, child) => IconButton(
              onPressed: () {
                ref.read<AppProvider>(appNotifier).addRemoveCart(product);
                if (ref.read<AppProvider>(appNotifier).cart.contains(product)) {
                  Fluttertoast.showToast(
                      msg: '${product.title} added to cart successfully!',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.white,
                      textColor: Colors.white,
                      fontSize: 12.0);
                }
              },
              icon: Icon(
                ref.read<AppProvider>(appNotifier).cart.contains(product)
                    ? Icons.check
                    : Icons.add_shopping_cart_rounded,
                color: ref.read<AppProvider>(appNotifier).cart.contains(product)
                    ? Colors.green
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((product.rating ?? '-').toString()),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.amber,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductListTile extends ConsumerWidget {
  const ProductListTile({
    super.key,
    required this.product,
    required this.appNotifier,
    required this.isCart,
  });

  final ChangeNotifierProvider<AppProvider> appNotifier;
  final ProductSchema product;
  final bool isCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppProvider appProviderRead = ref.read<AppProvider>(appNotifier);
    String productDesc = (product.description ?? '-').toString();
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: product.thumbnail != null
                ? Image.network(
                    product.thumbnail!,
                    fit: BoxFit.contain,
                  )
                : null,
          ),
          const SizedBox(width: 7),
          const VerticalDivider(thickness: 1),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (product.title ?? '-').toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Text(
                    productDesc,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('\$ ${(product.price ?? '-')}'),
                isCart
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              appProviderRead.reduceQuantity(product);
                            },
                            icon: const Icon(
                              Icons.remove,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Consumer(
                            builder: (context, WidgetRef ref, child) => Text(
                              ref
                                  .watch<AppProvider>(appNotifier)
                                  .cart[appProviderRead.cart.indexOf(product)]
                                  .count
                                  .toString(),
                            ),
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              appProviderRead.addQuantity(product);
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 16,
                            ),
                          ),
                        ],
                      )
                    : Consumer(
                        builder: (context, WidgetRef ref, child) => IconButton(
                          onPressed: () {
                            ref
                                .read<AppProvider>(appNotifier)
                                .addRemoveCart(product);
                            Fluttertoast.showToast(
                              msg:
                                  '${product.title} ${ref.read<AppProvider>(appNotifier).cart.contains(product) ? 'added to ' : 'removed from'} cart successfully!',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 12.0,
                            );
                          },
                          icon: Icon(
                            ref
                                    .read<AppProvider>(appNotifier)
                                    .cart
                                    .contains(product)
                                ? Icons.check
                                : Icons.add_shopping_cart_rounded,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((product.rating ?? '-').toString()),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.amber,
                  ),
                ],
              ),
              if (isCart)
                IconButton(
                  onPressed: () {
                    appProviderRead.removeFromCart(product);
                  },
                  icon: const Icon(Icons.delete),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
