import 'package:flutter/material.dart';
import "my_home_page.dart";
import 'package:camera_app/image_tile/wall_screen.dart';

class TwoPanels extends StatefulWidget {
  final AnimationController controller;

  TwoPanels({this.controller});

  @override
  _TwoPanelsState createState() => new _TwoPanelsState();
}

class _TwoPanelsState extends State<TwoPanels> {
  static const header_height = 32.0;

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return new RelativeRectTween(
            begin: new RelativeRect.fromLTRB(
                0.0, backPanelHeight, 0.0, frontPanelHeight),
            end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(new CurvedAnimation(
            parent: widget.controller, curve: Curves.linear));
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    return new Container(
      color: Colors.blueGrey,
      child: new Stack(
        children: <Widget>[
          new Container(
            //color: theme.primaryColor,
            color: Colors.blueGrey,
            child: new Center(
              child: WallScreen()//new Text(
              //   "Back Panel",
              //   style: new TextStyle(fontSize: 24.0, color: Colors.white),
              // ),
            ),
          ),
          new PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: new Material(
              elevation: 12.0,
              color: Colors.blueGrey,
              borderRadius: new BorderRadius.only(
                  topLeft: new Radius.circular(16.0),
                  topRight: new Radius.circular(16.0)),
              child: new Column(
                  children: <Widget>[
                    new Container(
                      color: Colors.transparent,
                      height: header_height,
                      child: new Center(
                        child: new Text(
                          "select image",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                    new Expanded(
                      child: MyHomePage(title: "image sender",),
                    )
                  ],
                ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: bothPanels,
    );
  }
}