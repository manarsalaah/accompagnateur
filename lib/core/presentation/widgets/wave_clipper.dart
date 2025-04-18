import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0); // Start from the top-left corner
    var firstStart = Offset(size.width / 5, 0);
    var firstEnd = Offset(size.width / 2.25, 50); // Change the y-coordinate
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), 105); // Change the y-coordinate
    var secondEnd = Offset(size.width, 10); // Change the y-coordinate
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, size.height); // Draw a line to the bottom-right corner
    path.lineTo(0, size.height); // Draw a line to the bottom-left corner

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}