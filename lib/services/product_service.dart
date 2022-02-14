import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductServices extends ChangeNotifier {
  final String _baseUrl = "flutter-varios-fb678-default-rtdb.firebaseio.com";
  final List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;

  ProductServices() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, "products.json");
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, "products/${product.id}.json");
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

//update product in products list
    final index = products.indexWhere((prod) => prod.id == product.id);
    products[index] = product;

    print(decodedData);

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, "products.json");
    final resp = await http.post(url, body: product.toJson());
    final decodedData = jsonDecode(resp.body);

    product.id = decodedData['name'];

    products.add(product);

    return "product.id!";
  }
}
