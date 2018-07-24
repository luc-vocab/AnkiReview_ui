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

class Question extends StatefulWidget {
  Question({Key key,  this.questionString, this.textSize = 55.0, this.revealAnswerAnimationController}) : super(key: key);

  final String questionString;
  final double textSize;
  final AnimationController revealAnswerAnimationController;

  @override
  createState() => QuestionState();
}

class QuestionState extends State<Question> with SingleTickerProviderStateMixin {
  Animation<double> animation;

  initState() {
    super.initState();
    animation = Tween(begin: 32.0, end: 300.0).animate(widget.revealAnswerAnimationController)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: animation.value),
        alignment: Alignment.center,
        child: Text(
          widget.questionString,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: widget.textSize,
          ),
          textAlign: TextAlign.center,
        )
    );
  }
}

class Answer extends StatefulWidget {
  Answer({Key key, this.answerString, this.textSize = 55.0, this.revealAnswerAnimationController}) : super(key: key);

  final String answerString;
  final double textSize;
  final AnimationController revealAnswerAnimationController;

  @override
  createState() => AnswerState();
}

class AnswerState extends State<Answer> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var answerText = Text(
        widget.answerString,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: widget.textSize,
        ),
        textAlign: TextAlign.center
    );


    Widget answer = Container(
        padding:  EdgeInsets.only(top: 32.0),
        alignment: Alignment.topCenter,
        child: answerText

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
        widget.revealAnswerAnimationController.value = metrics.extentBefore / metrics.viewportDimension.toDouble();
      },
      child: pageView,
    );

    var card = Column(
        children: [
          Expanded(
              child: Container()
          ),
          Expanded(
            child: scrollNotification,
          )
        ]
    );

    return card;
  }
}

class Card extends StatefulWidget {
  @override
  createState() => CardState();
}

class CardState extends State<Card> with SingleTickerProviderStateMixin {

  //Animation<double> revealAnswerAnimation;
  AnimationController revealAnswerAnimationController;

  static const  _fontSize = 65.0;
  static const _padding = 28.0;
  var _questionBottomPadding = 0.0;

  static const _questionString = "travel around the world";
  static const _answerString = "wàan jàu sâi gâai 環遊世界";

  initState() {
    super.initState();
    revealAnswerAnimationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    var stackBottom = Question(
        questionString: _questionString,
        revealAnswerAnimationController: revealAnswerAnimationController,
        textSize: _fontSize,
    );
    var stackTop = Answer(
        answerString: _answerString,
        revealAnswerAnimationController: revealAnswerAnimationController,
        textSize: _fontSize,
    );

    return Stack(
      children: [
        stackBottom,
        stackTop
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
