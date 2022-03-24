import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CenteredViewDonation extends StatelessWidget{
  final Widget child;
  const CenteredViewDonation({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CenteredViewDonationMobile(child: child),
      tablet: CenteredViewDonationTabletDesktop(child: child),
    );
  }
}

class CenteredViewDonationTabletDesktop extends StatelessWidget{
  final Widget child;
  const CenteredViewDonationTabletDesktop({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 100, right: 100, top: 30),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1000),
        child: child,
      ),
    );
  }
}

class CenteredViewDonationMobile extends StatelessWidget{
  final Widget child;
  const CenteredViewDonationMobile({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: child,
      ),
    );
  }
}