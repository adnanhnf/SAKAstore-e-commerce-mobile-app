import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Produk.dart';

class ApiService {
  static const String apiUrl = 'http://localhost:8080/produk.php';

  static Future<List<Produk>> fetchProduk() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((produk) => Produk.fromJson(produk)).toList();
    } else {
      throw Exception('Failed to load produk');
    }
  }
}
