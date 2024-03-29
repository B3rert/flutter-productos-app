import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductServices extends ChangeNotifier {
  final String _baseUrl = "fl-productos-45fdf-default-rtdb.firebaseio.com";
  final List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;
  File? newPictureFile;

  final storage = new FlutterSecureStorage();

  ProductServices() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(
      _baseUrl,
      "products.json",
      {"auth": await storage.read(key: "token") ?? ""},
    );
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
    final url = Uri.https(
      _baseUrl,
      "products/${product.id}.json",
      {"auth": await storage.read(key: "token") ?? ""},
    );
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

//update product in products list
    final index = products.indexWhere((prod) => prod.id == product.id);
    products[index] = product;

    print(decodedData);

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(
      _baseUrl,
      "products.json",
      {"auth": await storage.read(key: "token") ?? ""},
    );
    final resp = await http.post(url, body: product.toJson());
    final decodedData = jsonDecode(resp.body);

    product.id = decodedData['name'];

    products.add(product);

    return "product.id!";
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/b3rert/image/upload?upload_preset=cx2foxjh");

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath("file", newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Algo salio mal");
      return null;
    }

    newPictureFile = null;

    final decodedData = jsonDecode(response.body);
    return decodedData["secure_url"];
  }
}
