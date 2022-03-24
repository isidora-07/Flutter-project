import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
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
    return Container(
      height: this.imageSize,
      width: this.imageSize,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),

      child: Container(
        margin: EdgeInsets.all(whiteMargin),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).textTheme.bodyText1.color,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(image),
          ),
        ),
      ),
    );
  }
}
