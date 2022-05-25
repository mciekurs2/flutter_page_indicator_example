import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int index) {
    // _pageController.jumpToPage(index);
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 800), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Example App')),
      body: SafeArea(
        child: Column(
          children: [
            PageIndicator(
              pageController: _pageController,
              itemCount: 12,
              onIndicatorSelected: _animateToPage,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: List.generate(12, (index) => _page('Page #$index')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _page(String text) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF373737),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(text),
      ),
    );
  }
}

class PageIndicator extends StatefulWidget {
  const PageIndicator({
    Key? key,
    required this.pageController,
    required this.itemCount,
    this.onIndicatorSelected,
  }) : super(key: key);

  final PageController pageController;
  final int itemCount;
  final Function(int index)? onIndicatorSelected;

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  double _position = 0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {
        _position = widget.pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: List.generate(widget.itemCount, (index) {
          bool isLast = widget.itemCount == index + 1;
          double dif = ((index - _position) * 255).abs();
          int alpha = dif <= 255 ? (255 - dif).toInt() : 0;

          double rotDif = ((index - _position) * 180).abs();
          int rot = rotDif <= 180 ? (180 - rotDif).toInt() : 0;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0.0 : 4.0),
              child: GestureDetector(
                onTap: () => widget.onIndicatorSelected?.call(index),
                child: Transform.rotate(
                  angle: rot * math.pi / 180,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: Colors.grey.shade700,
                        ),
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: Colors.green.withAlpha(alpha),
                        ),
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
