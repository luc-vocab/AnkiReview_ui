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

  var _fontSize = 48.0;

  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Widget question = Container(
        padding:  EdgeInsets.only(bottom: 32.0),
        child: Center (
            child: Text(
              "travel around the world",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _fontSize,
              ),
              textAlign: TextAlign.center,
            )
        ),
    );

    Widget answer = Container(
        padding:  EdgeInsets.only(top: 32.0),
        child: Text(
          "wàan jàu sâi gâai 環遊世界",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _fontSize,
          ),
          textAlign: TextAlign.center
      )

    );

    var children = [question, answer];

    var card = Column(
      children: [
        Expanded(
          child: question,
        ),
        Expanded(
          child: PageView(
          scrollDirection: Axis.vertical,
            children: [
              Container(),
              answer
            ]
          )
        )
      ]
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('AnkiReview'),
      ),
      body:  Container(
          child:card
      ),
    );

    /*
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
          //print(data);
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
    */


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
