import 'package:aqua_exchange/app/constants/environment.dart';
import 'package:aqua_exchange/app/models/product.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';

final dio = Dio();

class AppRepository {
  static Future<List<ProductSchema>> getProducts() async {
    EasyLoading.show();
    dynamic response = await dio.get(ENV.baseUrl);
    EasyLoading.dismiss();
    dynamic parsedRes = response.data;
    List<ProductSchema> productList = [];
    if (parsedRes['products'] != null) {
      List res = parsedRes['products'];
      productList = (res.map((e) => ProductSchema.fromJson(e)).toList());
    } else {}

    return productList;
  }
}
