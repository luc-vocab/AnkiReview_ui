// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

import 'ankireview.dart';
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
  Question({Key key,  this.questionString, this.textSize = 55.0, this.revealAnswerAnimationController, @required this.showAnswer}) : super(key: key);

  final String questionString;
  final double textSize;
  final AnimationController revealAnswerAnimationController;
  final bool showAnswer;

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

    var bottomPadding = animation.value;
    if(widget.showAnswer) {
      bottomPadding = animationEndPadding;
    }

    var questionContainer = Container(
        padding: EdgeInsets.only(bottom: bottomPadding ),
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
  Answer({Key key,
          @required this.answerString,
          this.textSize = 55.0,
          @required this.revealAnswerAnimationController,
          @required this.answerRevealed,
          this.showAnswer}) : super(key: key);

  final String answerString;
  final double textSize;
  final AnimationController revealAnswerAnimationController;
  final Function answerRevealed;
  final bool showAnswer;

  @override
  createState() => AnswerState();
}

class AnswerState extends State<Answer> with SingleTickerProviderStateMixin {
  var _currentPage = 0;

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

    Widget child;

    var cliprect = new ClipRect(
      child: new BackdropFilter(
        filter: new ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: answer,
      ),
    );

    if( ! widget.showAnswer ) {


      var pageView = PageView(
        scrollDirection: Axis.vertical,
        children: [
          Container(),
          cliprect
        ],
        onPageChanged: (pageNum) {
          _currentPage = pageNum;
        },
      );

      var scrollNotification = NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification) {
            if (_currentPage == 1) {
              // we have revealed the answer
              widget.answerRevealed();
            }
          }
          var metrics = notification.metrics;
          widget.revealAnswerAnimationController.value =
              metrics.extentBefore / metrics.viewportDimension.toDouble();
        },
        child: pageView,
      );

      child = scrollNotification;

    } else {
      child = cliprect;
    }

    var card = Column(
        children: [
          Expanded(
              child: Container()
          ),
          Expanded(
            child: child,
          )
        ]
    );

    return card;
  }
}

class Card extends StatefulWidget {
  Card({Key key, @required this.ankiCard, @required this.answerRevealed, this.showAnswer = false}) : super(key: key);

  final AnkiCard ankiCard;
  final Function answerRevealed;
  final bool showAnswer;

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
        questionString: widget.ankiCard.questionString,
        revealAnswerAnimationController: revealAnswerAnimationController,
        textSize: _fontSize,
        showAnswer: widget.showAnswer,
    );
    var stackTop = Answer(
        answerString: widget.ankiCard.answerString,
        revealAnswerAnimationController: revealAnswerAnimationController,
        textSize: _fontSize,
        answerRevealed: widget.answerRevealed,
        showAnswer: widget.showAnswer,
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
  var showingQuestion = true;
  var currentAnkiCard;
  var nextAnkiCard;
  PageController nextQuestionPageController;
  var _currentPage;

  var ankiCards = [
    AnkiCard(
      "travel around the world",
      "wàan jàu sâi gâai 環遊世界",
    ),
    AnkiCard(
      "I have to work late",
      "ngǒ jîu hóu cì sāu gūng 我要好遲收工",
    ),
    AnkiCard(
      "confident",
      "jǎu sêon sām 有信心",
    )
  ];

  @override
  void initState() {
    super.initState();

    currentAnkiCard = ankiCards[0];
    nextAnkiCard = ankiCards[1];

    nextQuestionPageController = new PageController(initialPage: 1);
  }

  void _handleAnswerRevealed() {
    setState(() {
      showingQuestion = false;
    });
  }

  void _handlePageChangeFinished() {
    if( _currentPage == 0 || _currentPage==2) {
      // move on to next card
      setState(() {
        currentAnkiCard = ankiCards[1];
        nextAnkiCard = ankiCards[2];
        showingQuestion = true;
      });
    }
  }

  void _handleOnPageChanged(int newValue) {
    _currentPage = newValue;
  }

  @override
  Widget build(BuildContext context) {




    Widget child = Card(ankiCard: currentAnkiCard,
                        answerRevealed: _handleAnswerRevealed);

    if( !showingQuestion ) {


      // need to show a pageview with next question
      var pageView = PageView(
        children: [
          Card(ankiCard: nextAnkiCard),
          Card(ankiCard: currentAnkiCard, showAnswer: true),
          Card(ankiCard: nextAnkiCard),
        ],
        controller: nextQuestionPageController,
        onPageChanged: _handleOnPageChanged,
      );

      var scrollNotification = NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification) {
            _handlePageChangeFinished();
          }
        },
        child: pageView,
      );

      child = scrollNotification;

    }

    return Stack(
      children: [
        Image.asset(
          'images/background_1.jpg',
          fit: BoxFit.cover,
          height: 800.0,
        ),
        Container(
          color: Colors.white.withOpacity(0.50),
        ),
        child,
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
