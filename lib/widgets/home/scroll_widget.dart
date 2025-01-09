// import 'package:flutter/material.dart';
// import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

// class ScrollCardStructure {
//   final Widget icon;
//   final String name;
//   final String? subtitle;

//   ScrollCardStructure({required this.icon, required this.name, this.subtitle});
// }

// class ScrollCard extends StatefulWidget {
//   const ScrollCard({super.key, this.height = 200, required this.items});

//   final double height;
//   final List<ScrollCardStructure> items;

//   @override
//   State<ScrollCard> createState() => _ScrollCardState();
// }

// class _ScrollCardState extends State<ScrollCard> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: widget.height,
//       child: FlutterCarousel.builder(
//           itemCount: widget.items.length,
//           itemBuilder: (context, index, realIndex) => SizedBox(),
//           options: CarouselOptions(height: widget.height)),
//     );
//   }
// }
