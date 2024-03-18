import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:lottie/lottie.dart';
import 'package:poker_game/card_container.dart';
import 'package:poker_game/helpers/check.dart';
import 'package:poker_game/helpers/const.dart';
import 'package:poker_game/data.dart';

class ExitBtnBody extends StatefulWidget {
  const ExitBtnBody({
    super.key,
  });

  @override
  State<ExitBtnBody> createState() => _ExitBtnBodyState();
}

class _ExitBtnBodyState extends State<ExitBtnBody> with SingleTickerProviderStateMixin {
  Random random = Random();
  int showCard = 0;
  int hiddenCard = 0;
  int mark = 0;
  String addMark = '';

  int counter = 10;
  bool isBack = true;

  final controller = FlipCardController();
  late AnimationController animationController;
  late Animation animation;

  void checkNumber(Check condition) {
    counter = 1;
    showMarkTimer();
    switch (condition) {
      case Check.small:
        if (showCard == hiddenCard) {
          mark--;
          addMark = '- 1';
          break;
        }
        int smallNumber = min(showCard, hiddenCard);
        if (hiddenCard == smallNumber) {
          mark++;
          addMark = '+ 1';
        } else {
          mark--;
          addMark = '- 1';
        }
        break;

      case Check.equal:
        if (showCard == hiddenCard) {
          mark += 3;
          addMark = '+ 3';
        } else {
          mark -= 2;
          addMark = '- 2';
        }
        break;

      case Check.large:
        if (showCard == hiddenCard) {
          mark--;
          addMark = '- 1';
          break;
        }
        int largeNumber = max(showCard, hiddenCard);
        if (hiddenCard == largeNumber) {
          mark++;
          addMark = '+ 1';
        } else {
          mark--;
          addMark = '- 1';
        }
        break;
    }

    //if too wrong
    if (mark <= -20) {
      showMyDialog("You shoutl not play this game. Your marks are very bad.");
    }

    // final check to show total result
    if (mark >= 20) {
      // isFinal = true;
      showMyDialog('Your mark is $mark');
    }
//flip animation
    controller.flipcard();
    isBack = false;
  }

  void nextQuestion() {
    showCard = random.nextInt(12) + 1;
    hiddenCard = random.nextInt(12) + 1;
  }

  void showMarkTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer1) {
      if (timer1.tick == 1) {
        timer1.cancel();
        setState(() {
          addMark = '';
        });
      }
    });
  }

  getTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter == 0) {
        timer.cancel();
        counter = 0;
      }
      setState(() {
        timer.isActive ? counter-- : '';
      });
      if (timer.tick == 10) {
        mark--;
        addMark = '- 1  TimeOut';
        isBack = false;
        controller.state!.isFront ? controller.flipcard() : null;
      } else if (timer.tick == 11) {
        timer.cancel();
        addMark = '';
      }
    });
  }

  void showMyDialog(String result) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Resut'),
            content: Text(result),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isBack = true;
                      mark = 0;
                      counter = 0;
                      getTimer();
                    });
                  },
                  icon: const Icon(Icons.next_plan_outlined))
            ],
          );
        });
  }

  void getAnimation() {
    //animation controller
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.addListener(() {
// print(animationController.status);
      if (animationController.status == AnimationStatus.completed) {
        animationController.reset();
      }
    });
  }

  @override
  void initState() {
    nextQuestion();
    getTimer();
    super.initState();
    getAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Text(
                        '$mark',
                        style: myTextStyle,
                      ),
                      Text(
                        ' Mks',
                        style: myTextStyle,
                      ),
                    ],
                  ),
                ),
                counter == 0
                    ? const Text('')
                    : Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Lottie.asset('assets/animations/timer.json',
                                width: 25, height: 25),
                            Text(
                              counter.toString().length == 1
                                  ? ' 0${counter.toString()}'
                                  : counter.toString(),
                              style: myTextStyle,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          Center(
            child: addMark == ''
                ? const Text('')
                : Text(
                    addMark,
                    style: const TextStyle(fontSize: 35),
                  ),
          ),
          CardContainer(
            showImage: photos[showCard - 1],
            hiddenImage: photos[hiddenCard - 1],
            controller: controller,
            animation: animation,
          ),
          isBack
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var value in Check.values)
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              checkNumber(value);
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white),
                          child: Text(
                            value
                                .toString()
                                .split('.')
                                .elementAt(1)
                                .toUpperCase(),
                            style: myTextStyle,
                          )),
                  ],
                ) 
              : Center(
                  child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      nextQuestion();
                      isBack = true;
                      controller.flipcard();
                      counter = 10;
                      getTimer();
                      //animation
                      animationController.forward();

                    });
                  },
                  style:
                      OutlinedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text(
                    'Next',
                    style: myTextStyle,
                  ),
                )),
          const Spacer()
        ],
      ),
    );
  }
}
