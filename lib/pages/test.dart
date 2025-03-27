import 'package:flutter/material.dart';

import 'dart:math';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'xxx');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool _showFrontSide;

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.flip),
            onPressed: _switchCard,
          ),
        ],
      ),
      body: DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        child: Center(
          child: Container(
            constraints: BoxConstraints.tight(Size.square(200.0)),
            child: _buildFlipAnimation(),
          ),
        ),
      ),
    );
  }

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  Widget _buildFlipAnimation() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 600),
      transitionBuilder: (widget, animation) {
        final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotateAnim,
          child: widget,
          builder: (context, widget) {
            // same direction for both sides
            // final isUnder = (ValueKey(_showFrontSide) != widget!.key);
            // var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
            // tilt *= isUnder ? -1.0 : 1.0;
            // final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;

            // reverse direction
            final isUnder = (ValueKey(_showFrontSide) != widget!.key);
            final tiltSign = _showFrontSide ^ isUnder ? -1.0 : 1.0;
            var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003 * tiltSign;

            final rawRotation = rotateAnim.value;
            final value = isUnder ? min(rawRotation, pi / 2) : (_showFrontSide ? -rawRotation : rawRotation);
            return Transform(
              transform: (Matrix4.rotationY(value)..setEntry(3, 0, tilt)),
              alignment: Alignment.center,
              child: widget,
            );
          },
        );
      },
      layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeInBack.flipped,
      child: _showFrontSide ? _buildFront() : _buildRear(),
    );
  }

  Widget _buildFront() {
    return __buildLayout(
      key: ValueKey(true),
      backgroundColor: Colors.blue,
      faceName: "Front",
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          child: FlutterLogo(),
        ),
      ),
    );
  }

  Widget _buildRear() {
    return __buildLayout(
      key: ValueKey(false),
      backgroundColor: Colors.blue.shade700,
      faceName: "Rear",
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          child: Center(child: Text("Flutter", style: TextStyle(fontSize: 50.0))),
        ),
      ),
    );
  }

  Widget __buildLayout(
      {required Key key, required Widget child, required String faceName, required Color backgroundColor}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Center(
        child: Text(faceName.substring(0, 1), style: TextStyle(fontSize: 80.0)),
      ),
    );
  }
}
