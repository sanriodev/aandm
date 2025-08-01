import 'dart:convert';

import 'package:aandm/models/cat_facts_api_model.dart';
import 'package:aandm/models/cat_picture_api_model.dart';
import 'package:http/http.dart';

class Backend {
  Future<List<CatFactsApiModel>> getCatFacts() async {
    final Uri url = Uri.parse('https://meowfacts.herokuapp.com/?count=5');
    final res = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          // ignore: avoid_dynamic_calls
          await json.decode(utf8.decode(res.bodyBytes))['data']
              as List<dynamic>;
      final ret = jsonData.map((e) => CatFactsApiModel.fromJson(e)).toList();

      return ret;
    } else {
      throw res;
    }
  }

  Future<List<CatPictureApiModel>> getCatPictures() async {
    final Uri url =
        Uri.parse('https://api.thecatapi.com/v1/images/search?limit=5');
    final res = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as List<dynamic>;
      final ret = jsonData.map((e) => CatPictureApiModel.fromJson(e)).toList();

      return ret;
    } else {
      throw res;
    }
  }
}
