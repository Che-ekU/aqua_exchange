import 'package:aqua_exchange/app/models/product.dart';
import 'package:aqua_exchange/app/widgets/product_card.dart';
import 'package:aqua_exchange/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:aqua_exchange/app/app_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late FToast fToast;
  late final Future<List<ProductSchema>> fetchProducts;

  final ChangeNotifierProvider<AppProvider> appChangeNotifier =
      ChangeNotifierProvider<AppProvider>((ref) => AppProvider());

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    fetchProducts = ref.read<AppProvider>(appChangeNotifier).fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppProvider appProviderRead =
        ref.read<AppProvider>(appChangeNotifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: const Text('E-Commerce App'),
        actions: [
          IconButton(
            onPressed: () {
              appProviderRead.changeView();
            },
            icon: Consumer(
              builder: (context, WidgetRef ref, child) => Icon(
                ref.watch(appChangeNotifier).isListView
                    ? Icons.list
                    : Icons.grid_on,
              ),
            ),
          ),
          _CartIcon(appChangeNotifier: appChangeNotifier),
          const SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder<List<ProductSchema>>(
        future: fetchProducts,
        builder: (context, AsyncSnapshot<List<ProductSchema>> snapshot) {
          Widget children = const SizedBox();
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (appProviderRead.products.isEmpty) {
                  children = const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        'Try again later',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  children = Consumer(
                    builder: (context, WidgetRef ref, child) => ref
                            .watch(appChangeNotifier)
                            .isListView
                        ? ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: appProviderRead.products.length,
                            itemBuilder: (context, index) => ProductListTile(
                              product: appProviderRead.products[index],
                              appNotifier: appChangeNotifier,
                              isCart: false,
                            ),
                          )
                        : GridView.count(
                            padding: const EdgeInsets.only(top: 10),
                            crossAxisCount: 2,
                            childAspectRatio:
                                300 / (MediaQuery.of(context).size.width + 100),
                            children: appProviderRead.products
                                .map(
                                  (e) => ProductGrid(
                                    product: e,
                                    appNotifier: appChangeNotifier,
                                  ),
                                )
                                .toList(),
                          ),
                  );
                }
              } else if (snapshot.hasError) {
                children = const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Something went wrong, Try again after sometime.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              break;
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              break;
          }

          return children;
        },
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({
    required this.appChangeNotifier,
  });

  final ChangeNotifierProvider<AppProvider> appChangeNotifier;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    CartScreen(appNotifier: appChangeNotifier),
              ),
            );
          },
          icon: const Icon(Icons.shopping_cart),
        ),
        Consumer(
          builder: (context, WidgetRef ref, child) => Container(
            margin: const EdgeInsets.only(right: 5),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal,
            ),
            child: Text(
              ref.watch(appChangeNotifier).cart.isNotEmpty
                  ? ref
                      .watch(appChangeNotifier)
                      .cart
                      .map((e) => e.count)
                      .reduce((value, element) => value + element)
                      .toString()
                  : '0',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
