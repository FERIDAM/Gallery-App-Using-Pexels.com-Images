import 'package:flutter/material.dart';
import 'package:gallery/gallerywidget.dart';
import 'package:gallery/http_call.dart';
import 'package:gallery/model.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  ScrollController scroll = ScrollController();

  getPhotos() async {
    await FetchPhotos.callPhotos();
    setState(() {});
  }

  getSearchImages() async {
    if (searchController.text.isNotEmpty) {
      await FetchPhotos.searchImage(searchUrl);
    }
  }

  bool isSearcing = false;
  String searchUrl = '';
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    getPhotos();
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getPhotos();
      }
    });
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          searchedImages.clear();
        });
      } else if (searchController.text.isNotEmpty) {
        setState(() {
          searchUrl =
              'https://api.pexels.com/v1/search?query=${searchController.text}&per_page=20';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          isSearcing
              ? SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                      controller: searchController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                width: 2.0, color: Colors.black)),
                        contentPadding: const EdgeInsets.all(5.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: 'Search Images',
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            getSearchImages();
                          },
                        ),
                      ),
                      onEditingComplete: () {
                        // getSearchImages();
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          IconButton(
              onPressed: () {
                setState(() {
                  isSearcing = !isSearcing;
                });
              },
              icon: isSearcing
                  ? const Icon(Icons.cancel_outlined)
                  : const Icon(Icons.search))
        ],
        elevation: 0,
        backgroundColor: const Color(0xFFEEEFF5),
        centerTitle: true,
        title: const Text(
          'Gallery',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: scroll,
        child: Column(
          children: [
            images.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
                : GridView.builder(
                    controller: scroll,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1 / 1.5),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GalleryWidget(
                                        photos: isSearcing
                                            ? searchedImages[index]
                                            : images[index]),
                                  ));
                            },
                            child: Image.network(
                                isSearcing
                                    ? searchedImages[index].src.portrait
                                    : images[index].src.portrait,
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                    itemCount:
                        isSearcing ? searchedImages.length : images.length,
                  )
          ],
        ),
      ),
    );
  }
}
