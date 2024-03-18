import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:poker_game/screen_one/body.dart';
import 'package:poker_game/screen_two/exit_btn_body.dart';

class Home extends StatelessWidget {
  Home({
    super.key,
  });

  bool choice = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 20.0,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText('Animation Game Lesson'),
                  WavyAnimatedText('18.03.2024'),
                  WavyAnimatedText('Homework'),
                  WavyAnimatedText('Soe Thu Htun'),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
            ),
            Column(
              children: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Body()));
                    },
                    child: const Text('Button 1')),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ExitBtnBody()));
                    },
                    child: const Text('Button 2')),
              ],
            ),
            Lottie.asset('assets/animations/poker.json',
                width: 120, height: 120)
          ],
        ),
      ),
    );
  }
}
