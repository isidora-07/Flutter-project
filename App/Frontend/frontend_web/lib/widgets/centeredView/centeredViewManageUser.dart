import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CenteredViewManageUser extends StatelessWidget{
  final Widget child;
  const CenteredViewManageUser({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CenteredViewManageUserMobile(child: child),
      tablet: CenteredViewManageUserTablet(child: child),
      desktop: CenteredViewManageUserDesktop(child: child),
    );
  }
}

class CenteredViewManageUserDesktop extends StatelessWidget{
  final Widget child;
  const CenteredViewManageUserDesktop({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 100, right: 100, top: 20),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200),
        child: child,
      ),
    );
  }
}

class CenteredViewManageUserTablet extends StatelessWidget{
  final Widget child;
  const CenteredViewManageUserTablet({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 70, right: 30, top: 20),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1000),
        child: child,
      ),
    );
  }
}

class CenteredViewManageUserMobile extends StatelessWidget{
  final Widget child;
  const CenteredViewManageUserMobile({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 2.5, right: 2.5, top: 10),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: child,
      ),
    );
  }
}