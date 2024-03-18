import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:lottie/lottie.dart';
import 'package:poker_game/card_container.dart';
import 'package:poker_game/helpers/check.dart';
import 'package:poker_game/helpers/const.dart';
import 'package:poker_game/data.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  Random random = Random();
  int showCard = 0;
  int hiddenCard = 0;
  int mark = 0;
  String addMark = '';

  int counter = 10;
  bool isHide = true;
  bool showAnswer = false;
  bool isCheck = false;

  late Timer timer;
  final controller = FlipCardController();
  late AnimationController animationController;
  late Animation animation;

  void checkNumber(Check condition) {
    counter = 0;
    showAnswer = false;
    isCheck = true;
    // getTimer();
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

    getCheckResultDialog();
  }

  void getCheckResultDialog() {
    //if too wrong
    if (mark <= -20) {
      timer.cancel();
      showMyDialog("Fail!");
    }

    // final check to show total result
    if (mark >= 20) {
      timer.cancel();
      showMyDialog('Congratulation! \n Score $mark');
    }
  }

  void nextQuestion() {
    showCard = random.nextInt(12) + 1;
    hiddenCard = random.nextInt(12) + 1;
  }

  void showMarkTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer1) {
      if (timer1.tick == 2) {
        timer1.cancel();
        setState(() {
          addMark = '';
        });
      }
    });
  }

  getTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter == 0) {
        if (showAnswer) {
          counter = 10;
          nextQuestion();
          controller.flipcard();
          showAnswer = false;
          isHide = true;

          animationController.forward();
        } else {
          if (!isCheck) {
            mark--;
            addMark = '- 1 (Time Out)';
            showMarkTimer();
          }
          isCheck = false;
          counter = 2;
          controller.flipcard();
          showAnswer = true;
          isHide = false;
          //check mark
          getCheckResultDialog();
        }
      }
      setState(() {
        counter--;
      });
      // print('timer tick is ==> ${timer.tick}');
    });
  }

  void showMyDialog(String result) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Result'),
            content: Text(result),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isHide = true;
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
  void dispose() {
    timer.cancel();
    timer.tick == 3 ? timer.cancel() : null;
    animationController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
if(mounted){
    super.setState(fn);
}
  }

  @override
  void initState() {
    nextQuestion();
    getTimer();
    getAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade400,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 1,
        title: const Text('Game Lesson'),
      ),
      body: Center(
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
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Text(
                          '$mark',
                          style: myTextStyle,
                        ),
                        Lottie.asset('assets/animations/coin.json',
                            width: 30, height: 30)
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
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
                  ? const Text(
                      '',
                      style: TextStyle(fontSize: 35),
                    )
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
            isHide
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
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: const Text(
                      '=Soe Thu Htun=',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
