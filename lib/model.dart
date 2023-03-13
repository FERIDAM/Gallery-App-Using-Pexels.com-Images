import 'dart:convert';

class ImageModel {
  final String photographer;
  final String photographer_url;
  final Src src;

  ImageModel(
      {required this.photographer,
      required this.photographer_url,
      required this.src});
  

  

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
        photographer: map['photographer'] ?? '',
        photographer_url: map['photographer_url'] ?? '',
        src: Src.fromMap(map['src']));
  }
  factory ImageModel.fromJson(String source) =>
      ImageModel.fromMap(json.decode(source));
}

class Src {
  final String original;
  final String large2x;
  final String large;
  final String small;
  final String portrait;
  final String landscape;

  Src({
    required this.original,
    required this.large2x,
    required this.large,
    required this.small,
    required this.portrait,
    required this.landscape,
  });

  factory Src.fromMap(Map<String, dynamic> map) {
    return Src(
      original: map['original'] ?? '',
      large2x: map['large2x'] ?? '',
      large: map['large'] ?? '',
      small: map['small'] ?? '',
      portrait: map['portrait'] ?? '',
      landscape: map['landscape'] ?? '',
    );
  }
}

List<ImageModel> images = [];
List<ImageModel> searchedImages = [];



//  'https://api.pexels.com/v1/curated?page=1&per_page=20'
//  {
//       "id": 12720385,
//       "width": 4396,
//       "height": 6590,
//       "url": "https://www.pexels.com/photo/woman-in-blue-and-brown-long-sleeve-shirt-holding-bouquet-of-flowers-12720385/",
//       "photographer": "Lauren Hogue",
//       "photographer_url": "https://www.pexels.com/@lauren-hogue-264849663",
//       "photographer_id": 264849663,
//       "avg_color": "#35302A",
//       "src": {
//         "original": "https://images.pexels.com/photos/12720385/pexels-photo-12720385.jpeg",
//         "large2x": "https://images.pexels.com/photos/12720385/pexels-photo-12720385.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
//         "large": "https://images.pexels.com/photos/12720385/pexels-photo-12720385.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
//         "medium": "https://images.pexels.com/photos/12720385/pexels-photo-12720385.jpeg?auto=compress&cs=tinysrgb&h=350",
//         "small": "https://images.pexels.com/photos/12720385/pexels-photo-12720385.jpeg?auto=compress&cs=tinysrgb&h=130",
//         "portrait": "https://images.pexels.com/photos/12720385/pexels-photo-12720385.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
//         "landscape": "https://images.pexels.com/photos/12720385/pexels-photo-12720385.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
//         "tiny": "https://images.pexels.com/photos/12720385/pexels-photo-12720385.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
//       },
//       "liked": false,
//       "alt": "Free stock photo of boho chic, boho style, bridal bouquet"
//     }
//   ],
//   "total_results": 8000,
//   "next_page": "https://api.pexels.com/v1/curated/?page=2&per_page=20"

