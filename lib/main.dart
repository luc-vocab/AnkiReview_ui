// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
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

  static const animationEndPadding = 150.0;

  initState() {
    super.initState();
    animation = Tween(begin: 32.0, end: animationEndPadding).animate(widget.revealAnswerAnimationController)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
  }

  @override
  Widget build(BuildContext context) {

    var questionContainer = Container(
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


    var cliprect = new ClipRect(
      child: new BackdropFilter(
        filter: new ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: questionContainer,
        ),
      );

    return cliprect;
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
        padding:  EdgeInsets.only(top: 0.0),
        alignment: Alignment.topCenter,
        child: answerText

    );

    var cliprect = new ClipRect(
      child: new BackdropFilter(
        filter: new ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: answer,
      ),
    );

    var pageView = PageView(
        scrollDirection: Axis.vertical,
        children: [
          Container(),
          cliprect
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
  Card({Key key, this.questionString, this.answerString}) : super(key: key);

  final String questionString;
  final String answerString;

  @override
  createState() => CardState();
}

class CardState extends State<Card> with SingleTickerProviderStateMixin {

  AnimationController revealAnswerAnimationController;
  static const  _fontSize = 65.0;

  initState() {
    super.initState();
    revealAnswerAnimationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    var stackBottom = Question(
        questionString: widget.questionString,
        revealAnswerAnimationController: revealAnswerAnimationController,
        textSize: _fontSize,
    );
    var stackTop = Answer(
        answerString: widget.answerString,
        revealAnswerAnimationController: revealAnswerAnimationController,
        textSize: _fontSize,
    );

    return Stack(
      children: [
        stackBottom,
        stackTop
      ]
    );
  }
}

class Reviewer extends StatefulWidget {
  Reviewer({Key key}) : super(key: key);

  @override
  createState() => ReviewerState();
}

class ReviewerState extends State<Reviewer> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'images/background_1.jpg',
          fit: BoxFit.cover,
          height: 800.0,
        ),
        Container(
          color: Colors.white.withOpacity(0.40),
        ),
        PageView(
        children: [
          Card(
            questionString: "travel around the world",
            answerString: "wàan jàu sâi gâai 環遊世界",
          ),
          Card(
            questionString: "I have to work late",
            answerString: "ngǒ jîu hóu cì sāu gūng 我要好遲收工",
          ),
          Card(
            questionString: "confident",
            answerString: "jǎu sêon sām 有信心",
          )
        ]
        )
      ]
    );
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
            child: Reviewer()
        ),
      ),
    );
  }
}
