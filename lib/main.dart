// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'dart:math';
// Uncomment lines 7 and 10 to view the visual layout at runtime.
//import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

/*
 * travel around the world
 * 環遊世界
 * wàan jàu sâi gâai
 */

class Card extends StatefulWidget {
  @override
  createState() => CardState();
}

class CardState extends State<Card> with SingleTickerProviderStateMixin {
  var _dragStartOffset;

  Animation<double> questionAnimation;
  Animation<double> answerAnimation;
  Animation<double> opacityAnimation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    questionAnimation = Tween(begin: 250.0, end: 150.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    answerAnimation = Tween(begin: 200.0, end: 32.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

  }


  @override
  Widget build(BuildContext context) {
    Widget question = Container(
        padding:  EdgeInsets.only(top: questionAnimation.value),
        child: Center (
            child: Text(
              "travel around the world",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48.0,
              ),
              textAlign: TextAlign.center,
            )
        ),
    );

    Widget answer = Container(
        padding:  EdgeInsets.only(top: answerAnimation.value),
        child: Opacity(
          opacity: opacityAnimation.value,
          child: Text(
              "wàan jàu sâi gâai 環遊世界",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48.0,
              ),
              textAlign: TextAlign.center,
            )
        )
    );

    var children = [question, answer];

    var child = GestureDetector(
        onTap: () {
            controller.reset();
        },
        onVerticalDragUpdate: (data) {
          // print(data);
          var currentOffset = data.globalPosition;
          var travel = _dragStartOffset - currentOffset;
          // print(travel);

          if(travel.dy <0 )
          {
            return;
          }

          // cannot be lower than zero
          var travelY = max<double>(0.0, travel.dy);
          // cannot be higher than 100
          travelY = min<double>(200.0, travelY);

          var animationPosition = travelY / 200.0;
          controller.value = animationPosition;
        },
        onVerticalDragEnd: (data) {
          if(controller.value > 0.50) {
            // make the animation continue on its own
            controller.forward();
          } else {
            // go back the other way
            controller.reverse();
          }
        },
        onVerticalDragStart: (data) {
          print(data);
          _dragStartOffset = data.globalPosition;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('AnkiReview'),
          ),
          body:  Container(
              child:Column(
                children: children,
              )
          ),
        )

    );


    return child;



  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      home: Card(),
    );
  }
}
