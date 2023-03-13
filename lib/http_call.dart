import 'dart:convert';

import 'package:gallery/model.dart';
import 'package:http/http.dart' as http;

String imageUrl = 'https://api.pexels.com/v1/curated?page=1&per_page=20';

class FetchPhotos {
  static callPhotos() async {
    try {
      String apiKey =
          'dA5AJDmX5fcK8gCfh8716RT9JYIwGOGU266BDhoOCVFq6m4xEtRowt5F';

      final response = await http.get(Uri.parse(imageUrl), headers: {
        'Authorization': apiKey,
      });

      final jsonBody = json.decode(response.body);
      List<dynamic> photos = jsonBody['photos'] as List;
      imageUrl = jsonBody['next_page'];

      for (var photo in photos) {
        images.add(ImageModel.fromMap(photo));
      }
    } catch (e) {
      print(e);
    }
  }

  static searchImage(String url) async {
    try {
      var info = Uri.parse(url);
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization':
            'dA5AJDmX5fcK8gCfh8716RT9JYIwGOGU266BDhoOCVFq6m4xEtRowt5F'
      });
      var refinePhoto = jsonDecode(response.body);
      var searchedPhotos = refinePhoto['photos'] as List;
      url = refinePhoto['next_page'];
      for (var photo in searchedPhotos) {
        searchedImages.add(ImageModel.fromMap(photo));
      }
    } catch (e) {
      print(e);
    }
  }
}
