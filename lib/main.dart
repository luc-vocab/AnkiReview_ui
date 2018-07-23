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
  var _padding = 0.0;

  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Widget question = Container(
        padding:  EdgeInsets.only(bottom: _padding),
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
        padding:  EdgeInsets.only(top: _padding),
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

    return card;

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
