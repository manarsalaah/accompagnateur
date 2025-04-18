import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImagePage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  FullScreenImagePage({required this.images, required this.initialIndex});

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Hero(
                    tag: widget.images[index],
                    child: Image.network(widget.images[index], fit: BoxFit.contain),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.black54,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.jumpToPage(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index ? Colors.white : Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.images[index],
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
