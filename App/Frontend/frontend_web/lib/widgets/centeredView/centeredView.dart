import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CenteredView extends StatelessWidget{
  final Widget child;
  const CenteredView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CenteredViewMobile(child: child),
      tablet: CenteredViewTabletDesktop(child: child),
    );
  }
}

class CenteredViewTabletDesktop extends StatelessWidget{
  final Widget child;
  const CenteredViewTabletDesktop({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 70, right: 70, top: 60),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200),
        child: child,
      ),
    );
  }
}

class CenteredViewMobile extends StatelessWidget{
  final Widget child;
  const CenteredViewMobile({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 35, right: 35, top: 30),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: child,
      ),
    );
  }
}