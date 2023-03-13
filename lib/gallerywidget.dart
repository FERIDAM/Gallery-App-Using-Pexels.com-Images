// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gallery/model.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class GalleryWidget extends StatefulWidget {
  final ImageModel photos;
  const GalleryWidget({super.key, required this.photos});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  PageController pageController = PageController();

  String selected = '';
  @override
  void initState() {
    selected = widget.photos.src.portrait;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List imageOrientations = [
      widget.photos.src.portrait,
      widget.photos.src.landscape,
      widget.photos.src.large,
      widget.photos.src.large2x,
      widget.photos.src.original,
      widget.photos.src.small
    ];
    List imageOrientationsName = [
      'Portrait',
      'Landscape',
      'Large',
      'Large2x',
      'Original',
      'Small'
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Gallery',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Photographer: ${widget.photos.photographer}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  selected,
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
              ),
              Positioned(
                  top: 435,
                  left: 10,
                  child: Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 25,
                            weight: 15,
                          ),
                          onPressed: () => shareImage(context),
                        )),
                  )),
              Positioned(
                  top: 435,
                  left: 70,
                  child: Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 25,
                            weight: 15,
                          ),
                          onPressed: () => downloadImage(context, selected),
                        )),
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                imageOrientations.length,
                (index) => Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () =>
                              changeOrientation(imageOrientations[index]),
                          child: Container(
                            height: 100,
                            width: 75,
                            decoration:
                                const BoxDecoration(color: Colors.black87),
                            child: Image.network(
                              imageOrientations[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    )),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              imageOrientations.length,
              (index) => SizedBox(
                    width: 75,
                    child: Text(
                      imageOrientationsName[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  )),
        )
      ]),
    );
  }

  changeOrientation(orientation) {
    setState(() {
      selected = orientation;
    });
  }

  downloadImage(context, String orientation) async {
    if (Platform.isIOS || Platform.isAndroid) {
      await permission();
      var response = await Dio()
          .get(selected, options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: 60);
      toast('Image Saved', duration: const Duration(seconds: 3));
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      Directory dir = await getApplicationDocumentsDirectory();
      var pathList = dir.path.split('\\');
      pathList[pathList.length - 1] = 'Pictures';
      var imagePath = pathList.join('\\');
      var rand = Random();
      var next = rand.nextInt(1000000).toString();
      var pic = await File(join(imagePath, "pexels_walpaper", 'image$next.png'))
          .create(recursive: true);
      var response = await Dio()
          .get(selected, options: Options(responseType: ResponseType.bytes));
      await pic.writeAsBytes(Uint8List.fromList(response.data));
      toast('Wallpaper Saved', duration: const Duration(seconds: 3));
    }
    Navigator.pop(context);
  }

  permission() async {
    if (Platform.isIOS) {
      await Permission.photos.request();
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      final info = statuses[Permission.storage].toString();
      toast(info);
    }
  }

  shareImage(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;
    final urlImage = selected;
    final image = await http.get(Uri.parse(urlImage));
    final response = image.bodyBytes;
    final dir = (await getApplicationDocumentsDirectory()).path;
    final path = '$dir/image.png';
    File(path).writeAsBytesSync(response);
    await Share.shareXFiles([XFile(path)],
        text: 'pictures',
        subject: 'Share Now',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
