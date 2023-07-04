import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practical/constant/api_constant.dart';

import '../../model/media_model.dart';


class ApiService {
  static Future<MediaModel?> fetchMediaData() async {
    final response = await http.get(Uri.parse(ApiConstant.baseUrl));
   // print("controller ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MediaModel.fromJson(data);
    } else {
      return null;
    }
  }
}
