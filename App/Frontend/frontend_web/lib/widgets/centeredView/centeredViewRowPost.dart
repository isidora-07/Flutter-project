import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CenteredViewRowPost extends StatelessWidget{
  final Widget child;
  const CenteredViewRowPost({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CenteredViewPostMobile(child: child),
      tablet: CenteredViewPostTabletDesktop(child: child),
    );
  }
}

class CenteredViewPostTabletDesktop extends StatelessWidget{
  final Widget child;
  const CenteredViewPostTabletDesktop({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 100, right: 100, top: 20),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child: child,
      ),
    );
  }
}

class CenteredViewPostMobile extends StatelessWidget{
  final Widget child;
  const CenteredViewPostMobile({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: child,
      ),
    );
  }
}