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
  static const _padding = 28.0;
  var _questionBottomPadding = 0.0;

  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    var questionText = Text(
      "travel around the world",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: _fontSize,
      ),
      textAlign: TextAlign.center,
    );

    var answerText = Text(
        "wàan jàu sâi gâai 環遊世界",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _fontSize,
        ),
        textAlign: TextAlign.center
    );


    Widget question = Container(
            padding: EdgeInsets.only(bottom: _padding),
            alignment: Alignment.bottomCenter,
            child: questionText
    );

    Widget answer = Container(
        padding:  EdgeInsets.only(top: _padding),
        alignment: Alignment.topCenter,
        child: answerText

    );

    var underneath = Container(
        padding: EdgeInsets.only(bottom: _questionBottomPadding),
        alignment: Alignment.center,
        child: Text(
        "yo yo",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _fontSize,
        ),
        textAlign: TextAlign.center,
      )
    );

    var pageView = PageView(
        scrollDirection: Axis.vertical,
        children: [
          Container(),
          answer
        ]
    );

    var scrollNotification = NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        var metrics = notification.metrics;
        //print(metrics.extentBefore);
        //print(metrics.viewportDimension);
        //print(metrics.extentBefore);
        //print(metrics.extentInside);
        setState(() {
          _questionBottomPadding = metrics.extentBefore;
        });
      },
      child: pageView,
    );

    var card = Column(
      children: [
        Expanded(
          child: question,
        ),
        Expanded(
          child: scrollNotification,
        )
      ]
    );


    return Stack(
      children: [
        underneath,
        card
      ]
    );


    //return card;

  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('AnkiReview'),
        ),
        body:  Container(
            child:Card()
        ),
      ),
    );
  }
}
