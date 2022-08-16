import 'package:flutter/material.dart';
import 'package:sketch2real/drawingarea.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  List<DrawingArea> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(138, 35, 135, 1.0),
                  Color.fromRGBO(233, 64, 87, 1.0),
                  Color.fromRGBO(242, 113, 33, 1.0)
                ],
              ),
            ),
          ),
          _loading == true
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: 256,
                          height: 256,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 5.0,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: GestureDetector(
                            onPanDown: (DragDownDetails details) {
                              setState(() {
                                points.add(DrawingArea(
                                    point: details.localPosition,
                                    areaPaint: Paint()
                                      ..strokeCap = StrokeCap.round
                                      ..isAntiAlias = true
                                      ..color = Colors.black
                                      ..strokeWidth = 5.0));
                              });
                            },
                            onPanUpdate: (DragUpdateDetails details) {
                              print("update");
                              this.setState(() {
                                points.add(DrawingArea(
                                    point: details.localPosition,
                                    areaPaint: Paint()
                                      ..strokeCap = StrokeCap.round
                                      ..isAntiAlias = true
                                      ..color = Colors.black
                                      ..strokeWidth = 5.0));
                              });
                            },
                            onPanEnd: (DragEndDetails details) {
                              this.setState(() {
                                points.add(null);
                              });
                            },
                            child: SizedBox.expand(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                child: CustomPaint(
                                  painter: MyCustomPainter(points: points),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
