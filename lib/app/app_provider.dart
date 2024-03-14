import 'package:aqua_exchange/app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:aqua_exchange/app/app_repository.dart';

class AppProvider extends ChangeNotifier {
  List<ProductSchema> products = [];

  List<ProductSchema> cart = [];

  bool isListView = true;

  int totalPrice() {
    int totalPrice = cart.isEmpty
        ? 0
        : cart
            .map((e) => (e.price ?? 0) * e.count)
            .reduce((value, element) => value + element);
    return totalPrice;
  }

  double getGST() {
    double gst = totalPrice() * 0.18;
    return gst;
  }

  String totalAmount() {
    double total = totalPrice() + getGST();
    return total.toStringAsFixed(2);
  }

  void changeView() {
    isListView = !isListView;
    notify();
  }

  void addRemoveCart(ProductSchema product) {
    cart.contains(product)
        ? {
            cart.remove(product),
            product.count = 0,
          }
        : {
            cart.add(product),
            product.count++,
          };
    notify();
  }

  void removeFromCart(ProductSchema product) {
    cart.remove(product);
    product.count = 0;
    notify();
  }

  void addQuantity(ProductSchema product) {
    cart[cart.indexOf(product)].count++;
    notify();
  }

  void reduceQuantity(ProductSchema product) {
    if (cart[cart.indexOf(product)].count > 1) {
      cart[cart.indexOf(product)].count--;
    }
    notify();
  }

  Future<List<ProductSchema>> fetchProducts() async {
    products = await AppRepository.getProducts();
    return products;
  }

  void notify() => notifyListeners();
}
