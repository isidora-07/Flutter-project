import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  //
  final String image;
  final double imageSize;
  final double whiteMargin;
  final double imageMargin;
  CircleImage(
    this.image, {
    this.imageSize = 70.0,
    this.whiteMargin = 2.5,
    this.imageMargin = 4.0,
  });


  @override
  Widget build(BuildContext context) {
    // Gradient background container
    return Container(
      height: this.imageSize,
      width: this.imageSize,
      margin: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),

      // White background container between image and gradient
      child: Container(
        margin: EdgeInsets.all(whiteMargin),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(image),
          ),
        ),
      ),
    );
  }
}
