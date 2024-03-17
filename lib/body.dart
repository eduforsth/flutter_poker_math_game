import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:poker_game/card_container.dart';
import 'package:poker_game/check.dart';
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
  int right = 0;
  int wrong = 0;

  int counter = 10;
  bool isBack = true;

  final controller = FlipCardController();
  late AnimationController animationController;
  late Animation animation;

  void checkNumber(Check condition) {
    counter = 1;
    switch (condition) {
      case Check.small:
        if (showCard == hiddenCard) {
          wrong++;
          break;
        }
        int smallNumber = min(showCard, hiddenCard);
        hiddenCard == smallNumber ? right++ : wrong++;
        break;

      case Check.equal:
        showCard == hiddenCard ? right++ : wrong += 2;
        break;

      case Check.large:
        if (showCard == hiddenCard) {
          wrong++;
          break;
        }
        int largeNumber = max(showCard, hiddenCard);
        hiddenCard == largeNumber ? right++ : wrong++;
        break;
    }

    //if too wrong
    if(wrong >= 10 && wrong > right){
      showMyDialog("You shoutl not play this game. Your marks are very bad.");
    }

    // final check to show total result
    if (wrong + right >=20) {
      // isFinal = true;
      showMyDialog(' Wrong = $wrong | Right $right');
    }
//flip animation
    controller.flipcard();
    isBack = false;
  }

  void nextQuestion() {
    showCard = random.nextInt(12) + 1;
    hiddenCard = random.nextInt(12) + 1;
  }

  getTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter == 0) {
        timer.cancel();
        counter = 0;
      }
      setState(() {
       timer.isActive? counter-- : '';
        //  print('counter - $counter');
        // print('timer ${timer.tick}');
      });
      if (timer.tick == 10) {
        wrong++;
        isBack = false;
        timer.cancel();
        controller.state!.isFront ? controller.flipcard() : null;
      }
    });
  }

  void showMyDialog(String result) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Total Resut'),
              content: Text(result),
                  actions: [IconButton(onPressed: (){
                    Navigator.pop(context);
                    setState(() {
                      wrong = 0;
                      right = 0;
                      counter = 0;
                    });
                  }, icon: const Icon(Icons.next_plan_outlined))],);
        });
  }

  void getAnimation(){
        //animation controller
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.ease));
        animationController.addListener(() {
// print(animationController.status);
if(animationController.status == AnimationStatus.completed){
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Wrong - $wrong'),
              Text(
                counter == 0? '' : counter.toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Text('Right - $right')
            ],
          ),
          CardContainer(
              showImage: photos[showCard - 1],
              hiddenImage: photos[hiddenCard - 1],
              controller: controller,
              animation: animation,),
          isBack
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var value in Check.values)
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              checkNumber(value);
                            });
                          },
                          child:
                              Text(value.toString().split('.').elementAt(1))),
                  ],
                )
              : Center(
                  child: ElevatedButton(
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
                      child: const Text('Next'))),
          const Spacer()
        ],
      ),
    );
  }
}
