import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = "identitytoolkit.googleapis.com";
  final String _firebaseToken = "AIzaSyAmQMbb29UITsZWBgk8izI828-5RwTvqYs";

  final storage = new FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };

    final url = Uri.https(_baseUrl, "/v1/accounts:signUp", {
      "key": _firebaseToken,
    });

    final response = await http.post(
      url,
      body: json.encode(authData),
    );

    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: "token", value: decodedResp["idToken"]);
      // return decodedResp["idToken"];
      return null;
    } else {
      return decodedResp["error"]["message"];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };

    final url = Uri.https(_baseUrl, "/v1/accounts:signInWithPassword", {
      "key": _firebaseToken,
    });

    final response = await http.post(
      url,
      body: json.encode(authData),
    );

    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: "token", value: decodedResp["idToken"]);

      // return decodedResp["idToken"];
      return null;
    } else {
      return decodedResp["error"]["message"];
    }
  }

  Future logout() async {
    await storage.delete(key: "token");
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: "token") ?? "";
  }
}
