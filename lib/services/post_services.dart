import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ensiklopedia_model.dart';

class PostService {
  Future<List<NegaraModel>> fetchCountries() async {
    final url = Uri.parse('https://countries.dev/region/Europe');

    try {
      final response = await http.get(url);

      print('STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        final negara = data.map((item) => NegaraModel.fromJson(item)).toList();

        negara.sort((a, b) => a.nama.compareTo(b.nama));

        return negara;
      }

      throw Exception('Status API: ${response.statusCode}');
    } catch (e) {
      print('ERROR NEGARA: $e');
      throw Exception('Gagal memuat negara: $e');
    }
  }
}
