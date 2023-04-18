import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = "identitytoolkit.googleapis.com";
  final String _firebaseToken = "AIzaSyAmQMbb29UITsZWBgk8izI828-5RwTvqYs";

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      "email": email,
      "password": password,
    };

    final url = Uri.https(_baseUrl, "/v1/accounts:signUp", {
      "key": _firebaseToken,
    });

    final response = await http.post(
      url,
      body: json.encode(authData),
    );

    final Map<String, dynamic> decodedResp = json.decode(response.body);

    print(decodedResp);
  }
}
